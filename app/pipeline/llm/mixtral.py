import numpy
from IPython.display import clear_output
import sys

# fix triton in colab
!export LC_ALL="en_US.UTF-8"
!export LD_LIBRARY_PATH="/usr/lib64-nvidia"
!export LIBRARY_PATH="/usr/local/cuda/lib64/stubs"
!ldconfig /usr/lib64-nvidia

!git clone https://github.com/dvmazur/mixtral-offloading.git --quiet
!cd mixtral-offloading && pip install -q -r requirements.txt
!huggingface-cli download lavawolfiee/Mixtral-8x7B-Instruct-v0.1-offloading-demo --quiet --local-dir Mixtral-8x7B-Instruct-v0.1-offloading-demo

sys.path.append("mixtral-offloading")

from ..resources import singleton
import torch
from torch.nn import functional as F
from hqq.core.quantize import BaseQuantizeConfig
from huggingface_hub import snapshot_download
from IPython.display import clear_output
from tqdm.auto import trange
from transformers import AutoConfig
from transformers import AutoTokenizer
from src.build_model import OffloadConfig, QuantConfig, build_model

from typing import Any, List, Mapping, Optional
from langchain.callbacks.manager import CallbackManagerForLLMRun
from langchain_core.language_models.chat_models import SimpleChatModel
from langchain_core.messages import (
    HumanMessage,
    SystemMessage,
    AIMessage,
    BaseMessage
)
from langchain.prompts.chat import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

import os
sys.path.append(os.path.dirname(os.path.abspath("")))
from resources.singleton import SingletonMeta

class BaseModelMixtral(metaclass = SingletonMeta):

    def __init__(self, **kwargs: Any):
        model_name = "mistralai/Mixtral-8x7B-Instruct-v0.1"
        quantized_model_name = "lavawolfiee/Mixtral-8x7B-Instruct-v0.1-offloading-demo"
        state_path = "Mixtral-8x7B-Instruct-v0.1-offloading-demo"

        config = AutoConfig.from_pretrained(quantized_model_name)
        self.tokenizer = AutoTokenizer.from_pretrained(model_name,padding_side='left')
        device = torch.device("cuda:0")
        offload_per_layer = 1

        num_experts = config.num_local_experts

        offload_config = OffloadConfig(
            main_size=config.num_hidden_layers * (num_experts - offload_per_layer),
            offload_size=config.num_hidden_layers * offload_per_layer,
            buffer_size=4,
            offload_per_layer=offload_per_layer,
        )


        attn_config = BaseQuantizeConfig(
            nbits=4,
            group_size=64,
            quant_zero=True,
            quant_scale=True,
        )
        attn_config["scale_quant_params"]["group_size"] = 256


        ffn_config = BaseQuantizeConfig(
            nbits=2,
            group_size=16,
            quant_zero=True,
            quant_scale=True,
        )
        quant_config = QuantConfig(ffn_config=ffn_config, attn_config=attn_config)


        self.model = build_model(
            device=device,
            quant_config=quant_config,
            offload_config=offload_config,
            state_path=state_path,
        )

class Mixtral(SimpleChatModel):

    temperature: float = 0.7
    max_tokens: int = 512
    do_sample: bool = True
    top_p: float = 0.95
    system_message_workaround: bool = True
    device = torch.device("cuda:0")

    @property
    def _llm_type(self) -> str:
      return "mixtral"

    def __init__(self,**kwargs):
      super().__init__()
      self.temperature = kwargs.get("temperature",self.temperature)
      self.max_tokens = kwargs.get("max_tokens",self.max_tokens)
      self.do_sample = kwargs.get("do_sample",self.do_sample)
      self.top_p = kwargs.get("top_p",self.top_p)
      self.system_message_workaround = kwargs.get("system_message_workaround",self.system_message_workaround)
      self.mixtral = BaseModelMixtral()

    def parse_messages_for_model(self, messages: List[BaseMessage]):
        parsed_messages=[]

        for message in messages:
            # print(message,isinstance(message, AIMessage))
            if isinstance(message, HumanMessage):
                parsed_messages.append({"role":"user","content":message.content})
            elif isinstance(message, AIMessage):
                parsed_messages.append({"role":"assistant","content":message.content})
            elif isinstance(message, SystemMessage):
                if self.system_message_workaround:
                    parsed_messages.append({"role":"user","content":message.content})
                    parsed_messages.append({"role":"assistant","content": "ok"})

        return parsed_messages

    def _call(
        self,
        messages: List[BaseMessage],
        stop: Optional[List[str]] = None,
        run_manager: Optional[CallbackManagerForLLMRun] = None,
        **kwargs: Any,
    ) -> str:
        print
        messages=self.parse_messages_for_model(messages)
        mixtral = self.mixtral
        input_ids = mixtral.tokenizer.apply_chat_template(messages, return_tensors="pt").to(self.device)
        attention_mask = torch.ones_like(input_ids)
        answer = mixtral.model.generate(
              input_ids=input_ids,
              attention_mask=attention_mask,
              do_sample=self.do_sample,
              temperature=self.temperature,
              top_p=self.top_p,
              max_new_tokens=self.max_tokens,
              pad_token_id=mixtral.tokenizer.eos_token_id
              )


        decoded = mixtral.tokenizer.batch_decode(answer, skip_special_tokens=True)
        return decoded


    @property
    def _identifying_params(self) -> Mapping[str, Any]:
      """Get the identifying parameters."""
      return {"system_message_workaround": self.system_message_workaround, "temperature": self.temperature, "top_p": self.top_p, "max_tokens": self.max_tokens }

class AgentMixtral(UtilsChat):

  def __call__(self,**kwargs):
    self.temperature_llm = kwargs.get('temperature_llm',0.4)
    self.temperature_chat = kwargs.get('temperature_llm',0.7)

  def __init__(self,model_intent ,**kwargs):
    super().__init__()
    self.intent_recognition = model_intent()
    self.temperature_llm = kwargs.get('temperature_llm',0.4)
    self.temperature_chat = kwargs.get('temperature_llm',0.7)

    print("TEMPERATURA",self.temperature_llm)

    self.llm = Mixtral(temperature=self.temperature_llm,max_tokens=500)
    self.chat = Mixtral(temperature=self.temperature_chat,max_tokens=50,)
    self.output_parser = StrOutputParser()


    self.llm_prompt = ChatPromptTemplate.from_messages([
        ("system", """Você é um assistente especialista em construir instruções SQL. Crie uma query SQL no SQLITE que atenda a solicitação levando em conta SOMENTE as tabelas e campos enviados"""),
        ("human", """###Solicitação: {question} ###Tabelas: {table} ###Campos:{fields}"""),
        ("ai", """###RESPOSTA: """)])

    self.chat_prompt =ChatPromptTemplate.from_messages([
        ("system", """"Você é um assistente especialista em atender solicitações com dados extraidos de bancos de dados. Responda a solicitação EM PORTUGUÊS com o resultado fornecido."""),
        ("human", """###SOLICITAÇÃO:{question} ###RESULTADO:{result}""")])


    self.chain_llm = self.llm_prompt | self.llm | self.output_parser
    self.chain_chat = self.chat_prompt | self.chat | self.output_parser