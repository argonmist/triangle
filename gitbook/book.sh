#!/bin/bash
if [ $# -eq 0 ]; then
    echo "./book REPORT_IP"
    exit 1
fi
if [ -d "testcase" ] 
then
  rm -rf testcase
  mkdir testcase
else
  mkdir testcase
fi

if [ -d "src" ]
then
  rm -rf src
  mkdir src
else
  mkdir src
fi

# Generate SUMMARY.md
summary='SUMMARY.md'
echo "# Summary" > $summary
echo "* [Introduction](README.md)" >> $summary
echo "  * [TestCase](TESTCASE.md)" >> $summary

#get yaml full path and file name
file+=($(find $testcase_path -name '*.yaml'))
filename+=($(find $testcase_path -type f -printf "%f\n"))
echo "yaml full path:"
for i in ${file[@]}
do
  echo $i
  cmd="yq eval '.bdd.feature1[]' $i"
  value=($(eval $cmd))
  delete='-'
  value=( "${value[@]/$delete}" )
  for j in ${!value[@]}
  do
    if [ "${value[$j]}" == "feature:" ]; then
      pure_feature_value=$(echo ${value[$j+1]} | tr -d \''')
      feature_value+=($pure_feature_value)
    fi
    if [ "${value[$j]}" == "scenario:" ]; then
      pure_scenario_value=$(echo ${value[$j+1]} | tr -d \''')
      scenario_value+=($pure_scenario_value)
    fi
  done
done
echo ""
echo "features:"
#get unique feature_value
uniq=($(printf "%s\n" "${feature_value[@]}" | sort -u)); echo "${uniq[@]}"

#convert all .yaml file to .md file
for i in ${filename[@]}
do
  md+=(${i%.yaml}.md)
done

#generate all summary relation
#insert feature
for i in ${uniq[@]}
do
#  python3 gen_content.py ${file[i]}
  echo "    * [$i](CLASS.md)" >> $summary
done

#insert scenario
for i in ${!file[@]}
do
  for j in ${uniq[@]}
  do
    if [ "${feature_value[i]}" == "$j" ]; then
      insert="\* [${scenario_value[i]}](testcase\/${md[i]})"
      cmd="sed -i '/.*\[$j](/a \ \ \ \ \ \ $insert' $summary"
      eval $cmd
    fi
  done
done

#generate all testcase md
for i in ${!file[@]}
do
  md_path="testcase/${md[i]}"
  testcase_name=$(echo ${md[i]} | awk -F '.md' '{print $1}')
  echo $testcase_name >> $md_path
  echo "===" >> $md_path
  echo "\`\`\`" >> $md_path
  python3 gen_content.py ${file[i]}
  cat feature >> $md_path
  echo "\`\`\`" >> $md_path
  rm feature
done

#insert report page
echo "  * [Report](REPORT.md)" >> $summary
echo '<iframe width="100%" height="800" src="http://'$1':8883/" frameborder="0" allowfullscreen></iframe>' > REPORT.md

#generate gitbook
mv testcase src
mv *.md src 
cp pages/* src
cp -r plugin/* src
