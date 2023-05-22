Problem: I pushed to GIT without addong *.terraform to .itignore.

ERRoR Received:
```
$ git push origin main


remote: error: File .terraform/providers/registry.terraform.io/hashicorp/aws/4.67.0/windows_amd64/terraform-provider-aws_v4.67.0_x5.exe is 348.24 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
To https://github.com/deleonab/terraform-custom-module-eks.git
 ! [remote rejected] main -> main (pre-receive hook declined)
error: failed to push some refs to 'https://github.com/deleonab/terraform-custom-module-eks.git'
```


Attempts to Fix i.e remove the large file from the staged commit (terraform-provider-aws_v4.67.0_x5.exe)

#### This command removes the file from the Git index without deleting it from your local file system.
Step 1: git rm -r --cached .terraform/providers/registry.terraform.io/hashicorp/aws/4.67.0/windows_amd64/terraform-provider-aws_v4.67.0_x5.exe

##This did not work


Step 2:  
git filter-branch -f --index-filter 'git rm --cached -r --ignore-unmatch .terraform/'