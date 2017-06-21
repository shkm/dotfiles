alias deploy_staging="gco staging && git merge master && ggpush && cap staging deploy"
alias deploy_production="gco production && git merge staging && ggpush && cap production deploy"
