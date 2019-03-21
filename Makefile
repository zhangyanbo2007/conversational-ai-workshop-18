help:
	@echo "    train-nlu"
	@echo "        Train the natural language understanding using Rasa NLU."
	@echo "    train-core"
	@echo "        Train a dialogue model using Rasa core."
	@echo "    run-core"
	@echo "        Runs the core server"
	@echo "    run-actions"
	@echo "        Runs the action server"
	@echo "    run"
	@echo "        Runs the bot on the commandline"

train-memo:
	python3 -m rasa_core.train -s data-simulated/train -d domain.yml -o models/dialogue_memo -c memo.yml --augmentation 0

train-redp:
	python -m rasa_core.train -s data/core/ -d domain.yml -o models/dialogue -c redp.yml --augmentation 0

train-lstm-bin:
	python -m rasa_core.train -s data/core/ -d domain.yml -o models/dialogue -c lstm_bin.yml --augmentation 0

train-lstm-feat:
	python -m rasa_core.train -s data/core/ -d domain.yml -o models/dialogue -c lstm_feat.yml --augmentation 0

train-compare:
	python -m rasa_core.train compare --stories data/core/ -d domain.yml -o comparison_models -c redp.yml lstm_bin.yml lstm_feat.yml --augmentation 0 --runs 5

evaluate-compare:
	python -m rasa_core.evaluate compare --stories data/core/ --core comparison_models -o results/
	nohup python -u -m rasa_core.train compare --stories data-simulated/train -d domain.yml -o comparison_models -c redp_topics.yml redp.yml redp_no_skip.yml --augmentation 10 --runs 5 > train.out &

evaluate-compare:
	python3 -m rasa_core.evaluate compare --stories data-simulated/test --core comparison_models -o results/

evaluate:
	python3 -m rasa_core.evaluate --core models/dialogue_embed -s data/core/test

evaluate-topics:
	python3 -m rasa_core.evaluate --core models/dialogue_embed -s data/core/test --topics

run-core:
	python -m rasa_core.run --core models/dialogue --endpoints endpoints.yml

run-actions:
	python -m rasa_core_sdk.endpoint --actions actions

run:
	make run-actions&
	make run-core
