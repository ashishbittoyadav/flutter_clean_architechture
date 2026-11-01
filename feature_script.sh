index=0
pattern=""
while [ "$index" -lt 76 ]
do
	pattern="${pattern}="
	index=$((index + 1))

done
echo $pattern
v_index=0
while [ "$v_index" -lt 5 ]
do
	index=0
	printf "||"
	while [ "$index" -lt 25 ]
	do
		if [ "$index" = 5 ] && [ "$v_index" = 2 ]; then
			printf "Authomated file structure for clean Architecture"
		else
			printf ""
		fi
		printf " "
		index=$((index + 1))
	done
	printf "\n"
	v_index=$((v_index + 1))
done
echo $pattern

echo "enter the feature name in small letter (use '_' if there is multiple words):"
read feature_folder_name
mkdir $feature_folder_name


cd $feature_folder_name
mkdir data domain presentation
cd data
mkdir datasources models repository

cd ../domain
mkdir entity repository usecases

cd ../presentation
mkdir bloc pages widgets
cd bloc
touch "${feature_folder_name}_bloc.dart" "${feature_folder_name}_event.dart" "${feature_folder_name}_state.dart"

# navigate to the repository of the domain
cd ../../domain/repository
touch "${feature_folder_name}_repository.dart"

cd ../../data/datasources
touch "${feature_folder_name}_local_source.dart" "${feature_folder_name}_remote_source.dart"

cd ../models
touch "${feature_folder_name}_model.dart"

cd ../../domain
cd ./entity
touch "${feature_folder_name}_entity.dart"

echo "Do you want to create use cases now if y/n?"
read choice
let use_cases
if [ $choice = "y" ]; then
	while true
	do
		read -p "enter use case (in small letters) write q when done: " input
		if [ $input = "q" ]; then
			break
		fi
		use_cases="${use_cases}|${input}"
	done
fi

OLD_IFS=$IFS
IFS='|'

cd ../usecases

for use_case in $use_cases
do
	if [ -n "${use_case}" ]; then
		touch "${feature_folder_name}_${use_case}_use_case.dart"
	fi
done
