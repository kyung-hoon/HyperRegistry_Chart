.PHONY: archive index

archive:
	tar --exclude='.git' --exclude='.github' --exclude='.idea'\
				  --exclude='docs' --exclude='cert' --exclude='conf'\
				  --exclude='*.sh' --exclude='*.tpl' --exclude='*.md' --exclude='Makefile'\
				  -zcvf docs/hyperregistry-v2.2.2.tgz .

index:
	helm repo index docs
