TODO work:
   add singularity-run to makefile 
   review:
        datalad containers-add 
        datalad containers-run 

TODO execute:
    prepare to connect
    `globalprotect connect --portal vpn-linux.dartmouth.edu`
    
    prepare the env
    `ssh f006rq8@discovery.dartmouth.edu`

    https://dbic-handbook.readthedocs.io/en/latest/mri/dataaccess.html#discovery-filesystem
    enable recent git-annex (add this to .bashrc)
    ```
    ANNEX_BIN_PATH=/dartfs/rc/lab/D/DBIC/DBIC/archive/git-annex/usr/lib/git-annex.linux/
    echo $PATH | grep -q "$ANNEX_BIN_PATH" || export PATH="$ANNEX_BIN_PATH:$PATH"
    ```

    Assert
    ```
    [f006rq8@discovery7 ~]$ which git-annex
    /dartfs/rc/lab/D/DBIC/DBIC/archive/git-annex/usr/lib/git-annex.linux/git-annex
    ```
    
    enable conda
    `source /optnfs/common/miniconda3/etc/profile.d/conda.sh`
    
    `conda info --envs | grep asmacdo-datalad` if not
        `conda create --name asmacdo-datalad python=3 anaconda`
        install datalad
        install reproman
    conda activate asmacdo-datalad


        orchestrata data
        datalad foreachsubdataset
            datalad get .
        reproman run `make singularity-run`
            -orc datalad-no-remote
            -sub slurm
             jp:
                num_processes
                num_nodes
                walltime
                queue
                job_name
    



 - 




