class build_pipeline(UtilsChat):
    def __init__(self,intent_recognition,generator_sql,generator_response):
        self.intent_recognition = intent_recognition
        self.llm = generator_sql.model
        self.llm_prompt_template = generator_sql.prompt
        self.chat = generator_response.model
        self.chat_prompt_template = generator_response.prompt

        self.chain_llm = self.llm_prompt_template | self.llm | self.output_parser
        self.chain_chat = self.chat_prompt_template | self.chat | self.output_parser

        pass