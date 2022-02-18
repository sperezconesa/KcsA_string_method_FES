.PHONY: make_conda update_conda remove_conda update_data update_data_dry update_data_dry

.ONESHELL:

PROJECT_NAME = string_sims

make_conda:
	conda env create -f environment.yml
	conda activate $(PROJECT_NAME)
	ipython kernel install --user --name=$(PROJECT_NAME)

update_conda:
	conda env update --file environment.yml
	ipython kernel install --user --name=$(PROJECT_NAME)

remove_conda:
	conda remove --name=$(PROJECT_NAME) --all

update_data:
	 grep -v "^#" data/raw/dir_list.txt | while read a b;do rsync -rauLih --del  --progress  --exclude-from=data/raw/exclude_list.txt   $$a $$b;done
	 python  src/data/get_external_data.py

update_data_dry:
	 grep -v "^#" data/raw/dir_list.txt | while read a b; do echo $$a $$b; rsync -raunLih  --del --exclude-from=data/raw/exclude_list.txt   $$a $$b;done

update_data_dry_verbose:
	 grep -v "^#" data/raw/dir_list.txt | while read a b;do rsync -raunLivvvh --del  --exclude-from=data/raw/exclude_list.txt   $$a $$b;done

clean:
	find . -iname \#* -exec rm {} \;
	find . -iname "slurm*err" -exec rm {} \;
	find . -iname "slurm*out" -exec rm {} \;

format:
	black -l 79 .
	isort .

help:
	@echo "Possible options:"
	@echo "make_conda"
	@echo "update_conda"
	@echo "remove_conda"
	@echo "update_data"
	@echo "update_data_dry"
