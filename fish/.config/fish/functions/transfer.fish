function transfer --description 'Transfer file up to transfer.sh'
  curl --upload-file $argv[0] https://transfer.sh/$argv[1]
end
