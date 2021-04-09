#!/usr/bin/env bash

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "Prerequisite: gcloud installed and compute admin role permission"
      echo -e "\n"
      echo "Use this command to manage your instance groups"
      echo -e "\n"
      echo "Usage: COMMAND -g <your-instance-group> -z <instance-zone> -i <your-instance> -p <your-project-id> ( -rm or -a )"
      echo " "
      echo "options:"
      echo " "
      echo "COMMAND [options] [arguments]"
      echo -e "\n"
      echo "-h,   --help               show brief help"
      echo "-lp,  --list-project       list project id, ( usage : e.g. command -lp )"
      echo "-lg,  --list-group         list instance-group, ( usage: e.g. command -p <your-project-id> -lg )"
      echo "-gm,  --group-member       list instance-group member, (usage : command -p <your-project-id> -g <your-instance-group -gm)"
      echo "-p,   --project            Your project id"
      echo "-z,   --zone               Instance zone"
      echo "-g,   --group              Instance group"
      echo "-rm,  --remove             Remove from instance-group (usage: only at the end of command)"
      echo "-a,   --add                Add to instance-group (usage: only at the end of command)"
      exit 0
      ;;
    -rm|--remove)
      shift
      if test $# -eq 0; then
        export remove=true
        echo "You're going to remove instance:$INSTANCE from group:$GROUP"
      else
        echo "Use (-a or -rm) only at the end of command, please read instructions (-h,--help)"
        exit 1
      fi
      shift
      ;;
    -a|--add)
      shift
      if test $# -eq 0; then
        export add=true
        echo "You're going to add instance:$INSTANCE to group:$GROUP"
      else
        echo "Use (-a or -rm) only at the end of command, please read instructions (-h,--help)"
        exit 1
      fi
      shift
      ;;
    -lp|--list-project)
      shift
      if test $# -eq 0; then
        gcloud projects list --format='value(project_id)'
      else
        echo "Please don't use an arguments"
        exit 1
      fi
      shift
      ;;
    -lg|--list-group)
      shift
      if test $# -eq 0; then
        gcloud compute instance-groups list --project=$PROJECT
      else
        echo "Please don't use an arguments or specify your project_id first"
        exit 1
      fi
      shift
      ;;
    -gm|--group-member)
      shift
      if test $# -eq 0; then
        gcloud compute instance-groups list-instances $GROUP --project=$PROJECT
      else
        echo "Please don't use an arguments or specify your instance-group and project_id first"
        exit 1
      fi
      shift
      ;;
    -p|--project)
      shift
      if test $# -gt 0; then
        export PROJECT="$1"
        echo "Selected project id : $1"
      else
        echo "At Least one arguments is needed or you haven't specify project_id"
        exit 1
      fi
      shift
      ;;
    -i|--instance)
      shift
      if test $# -gt 0; then
        export INSTANCE="$1"
        echo "Selected instance : $1"
      else
        echo "At Least one arguments is needed or you haven't specify instance"
        exit 1
      fi
      shift
      ;;
    -z|--zone)
      shift
      if test $# -gt 0; then
        export ZONE="$1"
        echo "Selected Zone : $1"
      else
        echo "At Least one arguments is needed or you haven't specify zone"
        exit 1
      fi
      shift
      ;;
    -g|--group)
      shift
      if test $# -gt 0; then
        export GROUP="$1"
        echo "Selected instance-group : $1"
      else
        echo "At Least one arguments is needed or you haven't specify instance-group"
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ $GROUP != "" && $ZONE != "" && $INSTANCE != "" && $PROJECT != "" && $remove = true ]]; then
  gcloud compute instance-groups unmanaged remove-instances $GROUP \
  --zone=$ZONE \
  --instances=$INSTANCE \
  --project=$PROJECT
elif [[ $GROUP != "" && $ZONE != "" && $INSTANCE != "" && $PROJECT != "" && $add = true ]]; then
  gcloud compute instance-groups unmanaged add-instances $GROUP \
  --zone=$ZONE \
  --instances=$INSTANCE \
  --project=$PROJECT
else
  echo ""
  echo "Thats it !"
fi
if [[ $remove = true ]]; then
  echo "Removing Instance Succeeded"
elif [[ $add = true ]]; then
  echo "Adding Instance Succeeded"
fi
exit 0
