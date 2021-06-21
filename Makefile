.PHONY: archive index

archive:
	tar --exclude='.git' --exclude='.github' --exclude='.idea'\
				  --exclude='cert' --exclude='conf'\
				  --exclude='*.sh' --exclude='*.tpl' --exclude='*.md' --exclude='Makefile'\
				  -zcvf .github/GitHubPages/hyperregistry-v2.2.2.tgz .

index:
	helm repo index .github/GitHubPages
