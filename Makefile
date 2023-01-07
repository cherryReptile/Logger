USER:=$(shell id -u)
GROUP:=$(shell id -g)

init:
	ansible-playbook -i deploy/hosts.yml deploy/local.yml -t configuration -e @deploy/vars/local.yml -e "USER=$(USER)" -e "GROUP=$(GROUP)" --ask-vault-pass
build:
	docker compose run --rm app sh -c "CGO_ENABLED=0 go build -o app/tmp/app app/cmd/main.go"
run:
	docker compose run --rm app sh -c "CGO_ENABLED=0 go build -o app/tmp/app app/cmd/main.go && ./app/tmp/app"
up:
	docker-compose up -d && make log
down:
	docker-compose stop
exec:
	docker-compose exec app sh
exec.root:
	docker-compose exec -u root app bash
log:
	docker-compose logs -f app