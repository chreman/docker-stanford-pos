FROM java:8

RUN apt-get install -y \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /home
ADD http://nlp.stanford.edu/software/stanford-postagger-2015-04-20.zip pos.zip
RUN unzip pos.zip

WORKDIR /home/stanford-postagger-2015-04-20

RUN cp stanford-postagger.jar stanford-postagger-withModel.jar
RUN mkdir -p edu/stanford/nlp/models/pos-tagger/english-left3words
RUN cp models/english-left3words-distsim.tagger edu/stanford/nlp/models/pos-tagger/english-left3words 
RUN jar -uf stanford-postagger-withModel.jar edu/stanford/nlp/models/pos-tagger/english-left3words/english-left3words-distsim.tagger

ENTRYPOINT exec java \
	-mx300m \
	-cp stanford-postagger-withModel.jar edu.stanford.nlp.tagger.maxent.MaxentTaggerServer \
	-model edu/stanford/nlp/models/pos-tagger/english-left3words/english-left3words-distsim.tagger \
	-port 2020 

EXPOSE 2020