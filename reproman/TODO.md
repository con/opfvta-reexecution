TODO work:
   add singularity-run to makefile 
   review:
        datalad containers-add 
        datalad containers-run 

TODO execute:
## prior to connect

    `globalprotect connect --portal vpn-linux.dartmouth.edu`

## connect
    
    connect 
    `ssh f006rq8@discovery.dartmouth.edu`

    use interactive node for env preparation
    `ssh x01`

## installation of dependencies

    Install the right version of git-annex  
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
    
    `conda create --name asmacdo-datalad python=3 anaconda`
    `conda install -c conda-forge datalad -vv
    `which git-annex`
    ~/.conda/envs/asmacdo-datalad2/bin/git-annex
    `source ~/.bashrc`
    `which git-annex`
    /dartfs/rc/lab/D/DBIC/DBIC/archive/git-annex/usr/lib/git-annex.linux/git-annex
    install reproman
    pip install pip install git+https://github.com/ReproNim/reproman.git

## Orchestrate data

        orchestrata data
        datalad foreachsubdataset
            datalad get .

## Execute

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




