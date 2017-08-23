*** Settings ***
Library           OperatingSystem
Library           BuiltIn
Library           rm_test.py

*** Variables ***
${test_dir}					test_dir
${nonexistant_file}           test_dir/nonexistant_file.txt
${existant_file}           test_dir/existant_file.txt
${empty_dir}           test_dir/empty_dir/
${more_than3_dir}           test_dir/more_than3_dir/
${str_list} 				  
${stdin_str_all_no}  
${stdin_str_all_yes}
*** Keywords ***
Create test directory
	Remove directory   ${test_dir}    recursive=True
    Create file   ${existant_file}  
    Create directory   ${empty_dir}
    : for   ${index}   in range    1   5
    \	Create file   ${more_than3_dir}/test${index}.txt 





*** Test Cases ***
	

Remove nonexistant file without ignoring error
    Create test directory
    Should Not Exist    ${nonexistant_file}
	rm remove      ${nonexistant_file} 
    Status Should Be   rm: невозможно удалить «${nonexistant_file}»: Нет такого файла или каталога
    Should Not Exist    ${nonexistant_file}

Remove nonexistant file with ignoring error
    Create test directory
    Should Not Exist    ${nonexistant_file}
	rm remove         -f ${nonexistant_file}
    Should Not Exist    ${nonexistant_file}



Remove existant file
    Create test directory
    Should Exist    ${existant_file}

	rm remove      ${existant_file} 	
	Status Should Be   ${EMPTY}

    Should Not Exist    ${existant_file}


Remove directory with key -rf 
	Log to console     \n#Remove directory and their contents recursively \n#and ignore nonexistant files and never prompt before removing
    Create test directory
	rm remove      -rf ${test_dir} 
	Status Should Be   ${EMPTY}
	Should Not Exist    ${test_dir}

	
Remove directory prompt once before removing recursively
    Create test directory
   	rm remove   -rI ${test_dir}    stdin_str=no  
	Should Exist    ${test_dir}
	rm remove   -rI ${test_dir}    stdin_str=yes
	Should Not Exist    ${test_dir}
	

Remove more than three files with prompt once before removing 
    Create test directory
    @{files} =   List Files In Directory   ${more_than3_dir} 
	:FOR    ${file}    IN    @{files}
    \    ${str_list} =   Catenate  ${str_list}     ${more_than3_dir}${file}
	rm remove   -rI ${str_list}  stdin_str=no

   	:FOR    ${file}    IN    @{files}
    \    Should Exist    ${more_than3_dir}${file}
	

	rm remove   -rI ${str_list}    stdin_str=yes  
   	:FOR    ${file}    IN    @{files}
    \    Should Not Exist    ${more_than3_dir}${file}
		
Remove more than three files with prompt before every removal
    Create test directory
    @{files} =   List Files In Directory   ${more_than3_dir} 
	:FOR    ${file}    IN    @{files}
    \    ${str_list} =   Catenate  ${str_list}     ${more_than3_dir}${file}
    \	 ${stdin_str_all_no} =   Catenate  SEPARATOR=  ${stdin_str_all_no}   0  
    \	 ${stdin_str_all_yes} =   Catenate  SEPARATOR=  ${stdin_str_all_yes}   1  

	rm remove   -i ${str_list}  stdin_str=${stdin_str_all_no} 

   	:FOR    ${file}    IN    @{files}
    \    Should Exist    ${more_than3_dir}${file}
	

	rm remove   -i ${str_list}    stdin_str=${stdin_str_all_yes} 
   	:FOR    ${file}    IN    @{files}
    \    Should Not Exist    ${more_than3_dir}${file}
    Create test directory
asfa