function transfer --description 'Transfer file up to transfer.sh'
	curl --upload-file $argv https://transfer.sh/$argv
end
