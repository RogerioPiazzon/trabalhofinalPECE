from typing import Any, List, Mapping, Optional

from langchain.callbacks.manager import CallbackManagerForLLMRun
from langchain_core.language_models.llms import LLM
from langchain_core.language_models.chat_models import BaseChatModel, SimpleChatModel
from langchain_core.messages import (
    HumanMessage,
    SystemMessage,
    AIMessage,
    BaseMessage,
)
import maritalk

class ChatMaritalk(SimpleChatModel):
    api_key: str
    temperature: float = 0.7
    chat_mode: bool = True
    max_tokens: int = 512
    do_sample: bool = True
    top_p: float = 0.95
    system_message_workaround: bool = True

    @property
    def _llm_type(self) -> str:
        return "maritalk"

    def parse_messages_for_model(self, messages: List[BaseMessage]):
        parsed_messages=[]

        for message in messages:
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
        model = maritalk.MariTalk(key=self.api_key)
        stop_tokens=stop if stop is not None else []
        messages=self.parse_messages_for_model(messages)
        answer = model.generate(
            messages,
            temperature=self.temperature,
            max_tokens=self.max_tokens,
            stopping_tokens=stop_tokens,
            do_sample=self.do_sample,
            top_p=self.top_p,
            chat_mode=True,
        )

        return answer

    @property
    def _identifying_params(self) -> Mapping[str, Any]:
        """Get the identifying parameters."""
        return {"system_message_workaround": self.system_message_workaround, "temperature": self.temperature, "top_p": self.top_p, "max_tokens": self.max_tokens }
