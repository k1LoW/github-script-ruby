test:
	bundle exec ruby test/run_test.rb

build-base:
	docker build -f docker/Dockerfile . -t ghcr.io/k1low/github-script-ruby-base:latest

push-base: build-base
	docker push ghcr.io/k1low/github-script-ruby-base:latest

prerelease:
	git pull origin main --tag
	sed -i -e "s#FROM ghcr.io/k1low/github-script-ruby-base:.*#FROM ghcr.io/k1low/github-script-ruby-base:${VER}#g" Dockerfile
	ghch -w -N ${VER}
	git add CHANGELOG.md Dockerfile
	git commit -m'Bump up version number'
	git tag ${VER}
	git tag -f v2
	docker build -f docker/Dockerfile . -t ghcr.io/k1low/github-script-ruby-base:${VER}
	docker build -f docker/Dockerfile . -t ghcr.io/k1low/github-script-ruby-base:latest

# make release VER=$(git semv now)
release:
	docker push ghcr.io/k1low/github-script-ruby-base:${VER}
	docker push ghcr.io/k1low/github-script-ruby-base:latest
	git push origin main --tag -f

.PHONY: default test
