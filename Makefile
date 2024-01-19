candidates_setup:
	(cd scripts; ./setup_deps.sh candidates candidates)
stop:
	-docker-compose down
clean:
	-docker-compose down
	-docker volume rm kafka-data
	-docker volume rm prometheus-data
	-docker volume rm grafana-data
consume:
	(cd scripts; ./consume.sh)
candidates_reset:
	(cd scripts; ./app_reset.sh candidates)
	(cd scripts; ./app_reset.sh candidates-externals)
	rm -rf kafka-state-dir/candidates
	rm -rf kafka-state-dir/candidates-externals
	kaf topic delete candidates-externals
	kaf topic delete candidates
candidates_run:
	-rm -rf kafka-state-dir/candidates
	sbt candidates/run
candidates_run_jemalloc:
	-rm -rf kafka-state-dir/candidates
	env LD_PRELOAD=/usr/lib64/libjemalloc.so.2 sbt candidates/run
metrics:
	-docker-compose up -d prometheus grafana
