~/local/perl-5.22/bin/carton install
~/local/perl-5.22/bin/carton exec start_server --path /dev/shm/app.sock --backlog 16384 -- plackup -s Starlet --workers=4 --max-reqs-per-child 500000 --min-reqs-per-child 400000 -E production -a app.psgi
~/local/perl-5.22/bin/carton exec start_server --path /dev/shm/app.sock --backlog 16384 -- plackup -s Gazelle --max-workers=4 --max-reqs-per-child 500000 --min-reqs-per-child 400000 -E production -a app.psgi
