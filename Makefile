.PHONY: archive index

archive:
	-mkdir docs
	tar --exclude='.git' --exclude='.github' --exclude='.idea'\
				  --exclude='docs'\
				  --exclude='*.sh' --exclude='*.md' --exclude='Makefile'\
				  --exclude='*.swo' --exclude='*.swp'\
				  -zcvf docs/hyperregistry-v2.2.2.tgz .

index:
	helm repo index docs
