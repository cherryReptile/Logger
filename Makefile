include ${PWD}/.env

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
migrate:
	docker-compose exec auth migrate create -ext sql -dir grpc/internal/migrations ${name}
migrate.up:
	docker-compose exec auth migrate -database "postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):5432/$(DB_NAME)?sslmode=disable" -path grpc/internal/migrations up
migrate.down:
	docker-compose exec auth migrate -database "postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):5432/$(DB_NAME)?sslmode=disable" -path grpc/internal/migrations down
exec:
	docker-compose exec app sh
exec.root:
	docker-compose exec -u root app bash
log:
	docker-compose logs -f app