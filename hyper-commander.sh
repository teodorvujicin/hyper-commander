#! /usr/bin/env bash

function greet_user() {
    echo -e "Hello $USER!\n"
}

function print_menu() {
    echo -e "------------------------------"
    echo -e "| Hyper Commander            |"
    echo -e "| 0: Exit                    |"
    echo -e "| 1: OS info                 |"
    echo -e "| 2: User info               |"
    echo -e "| 3: File and Dir operations |"
    echo -e "| 4: Find Executables        |"
    echo -e "------------------------------"
}

function say_farewell() {
    echo "Farewell!"
}

function print_os_information() {
    operating_system=$(uname -s)
    node_name=$(uname -n)
    echo "$node_name $operating_system"
}

function print_user_information() {
    user_information=$(whoami)
    echo $user_information
}

function list_files_and_directories() {
    unfiltered_files_and_directories=(*)
    filtered_files_and_directories=()
    for file in "${unfiltered_files_and_directories[@]}"; do
        if [[ -f "$file" ]]; then
            modified_file="F $file\n"
            filtered_files_and_directories+=("$modified_file")
        elif [[ -d "$file" ]]; then
            modified_file="D $file\n"
            filtered_files_and_directories+=("$modified_file")
        fi
    done
    echo -e "${filtered_files_and_directories[@]}"
}

function print_file_menu() {
    echo -e "---------------------------------------------------"
    echo -e "| 0 Main menu | 'up' To parent | 'name' To select |"
    echo -e "---------------------------------------------------\n"
}

function print_files_and_directories_information() {
    echo "The list of files and directories:"
    list_files_and_directories
    print_file_menu
}

function print_file_edit_menu() {
    echo -e "---------------------------------------------------------------------"
    echo -e "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
    echo -e "---------------------------------------------------------------------"
}

function choose_file_menu_option() {
    read option
    while true; do
        case $option in
            "up")
                cd ..
                print_files_and_directories_information
                ;;
            "documents")
                cd documents
                print_files_and_directories_information
                ;;
            "main.sh" | "task.html" | "task-info.yaml" | "read.md" | "read.txt" | "readme.md")
                print_file_edit_menu
                read edit_function
                while true; do
                    case $edit_function in
                        0)
                            cd ..
                            print_files_and_directories_information
                            break
                            ;;
                        1)
                            rm $option
                            echo "$option has been deleted."
                            print_files_and_directories_information
                            break
                            ;;
                        2)
                            echo "Enter the new file name:"
                            read new_filename
                            mv $option $new_filename
                            echo -e "$option has been renamed as $new_filename\n"
                            print_files_and_directories_information
                            break
                            ;;
                        3)
                            chmod 666 $option
                            echo -e "Permissions have been updated."
                            ls -l
                            echo ""
                            print_files_and_directories_information
                            break;
                            ;;
                        4)
                            chmod 664 $option
                            echo -e "Permissions have been updated."
                            ls -l
                            echo ""
                            print_files_and_directories_information
                            break;
                            ;;
                        *)
                            print_file_edit_menu
                            ;;
                    esac
                    read edit_function
                done
                ;;
            0)
                break;
                ;;
            *)
                print_file_edit_menu
                ;;
        esac
        read option
        echo ""
    done
}

function search_executables() {
    echo -e "Enter an executable name:"
    read executable_name
    executable_path=$(which $executable_name)
    if [ -n "$executable_path" ]; then
        echo -e "Located in: $executable_path"
        echo -e "Enter arguments:"
        read arguments
        echo "./$executable_path $arguments"
    else
        echo "The executable with that name does not exist!"
    fi
}

greet_user
print_menu

read option
echo ""
while true; do
    case $option in
        0)
            say_farewell
            break
            ;;
        1)
            print_os_information
            print_menu
            ;;
        2)
            print_user_information
            print_menu
            ;;
        3)
            print_files_and_directories_information
            choose_file_menu_option
            print_menu
            ;;
        4)
            search_executables
            print_menu
            ;;
        *)
            print_file_edit_menu
            ;;
    esac
    read option
    echo ""
done