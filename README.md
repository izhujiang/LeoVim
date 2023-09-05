# LeoVim
## Installatin and Configuration
### Quick Install
1. clone the repo locally
git clone https://github.com/izhujiang/LeoVim.git ~/.config/nvim
Or
git clone https://github.com/izhujiang/LeoVim.git ~/repos/LeoVim
ln -s ~/repos/LeoVim ~/.config/nvim

2. post installation
install plugins via lazy.nvim and external tools by mason.nvim
nvim --headless "+Lazy! install" "+60sleep" +qa


## Usage
### Useful keybindings

#### Navagate
-- ], [
-- g

| Keymap      					| Description 					|
| --------------------- | --------------------- |
| ]{letter}							| next {L}							|
| [{letter							| previous {L}					|
| ]{Capital letter}		  | Last {L} 							|
| [{Capital letter}		  | First {}							|
| [`	  								| Alternate buffer 			|

| {letter}      | Description 				|
| ----------- | ------------------- |
| b					  | buffer							|
| t					  | tab									|
| q					  | quickfix						|
| l					  | loclist							|

#### Find
<leader>f{k}

| Keymap      | Description		 								|
| ----------- | ----------------------------- |
| <leader>`   | Switch buffers								|
| <leader>/	  | fuzzy find in cur_buffer			|
| <leader>\	  | Grep (root dir)								|
| <leader>:   | Command histories							|
| ..  				| 															|
| <leader>fa  | Autocommands									|
| <leader>fb  | Buffers												|
| <leader>fc  | Commands											|
| <leader>fc  | Command	history								|
| <leader>ff  | Files	(root)									|
| <leader>fF  | Files	(cwd)										|
| <leader>fg  | git_commits										|
| <leader>fG  | git_status										|
| <leader>fh  | Help_tags											|
| <leader>fH  | Highlights										|
| <leader>fk  | Keymaps												|
| <leader>fl  | live_grep (cwd)								|
| <leader>fL  | live_grep (root dir)					|
| <leader>fm  | Marks													|
| <leader>fM  | Man pages											|
| <leader>fo  | Options												|
| <leader>fq  | Quickfix											|
| <leader>fr  | Resume												|
| <leader>fw  | Word under cursor (cwd)				|
| <leader>fW  | Word under cursor (root dir) 	|
| ..					| 															|
| <leader>fd  | Document diagnostics					|
| <leader>fD  | Workspace diagnostics					|
| <leader>fs  | Lsp Document symbols					|
| <leader>fS  | Lsp Workspace symbols					|

#### Search and Replace
f/F, t/F 																		flit.nvim
s/S 																				leap.nvim
<leader>S or <leader>sw <leader>ss 					nvim-spectre


#### Toggle
<leader>u{char}   --  Toggle options
| Keymap      | Description 				|
| ----------- | ------------------- |
| <leader>uc  | conceallevel				|
| <leader>ud  | diagnostics					|
| <leader>uh  | inlay_hint					|
| <leader>ul  | relativenumber			|
| <leader>us  | spell								|
| <leader>uw  | wrap								|


<leader>a{char}   --  Toggle windows

| Keymap      	| Description 												|
| 	----------- | ----------------------------------- |
| <leader>ad  	| Dap UI                        			|
| <leader>a-  	| Trouble Todo-comments								|
| <leader>ac  	| Console Terminal(cwd)								|
| <leader>at  	| Quickfix/TroubleToggle quickfix			|


| Keymap      | Description 													|
| ----------- | ------------------------------------	|
| <Leader>ee  | Neo-tree filesystem	root							|
| <Leader>ec	| Neo-tree filesystem	cwd								|
| <Leader>eb	| Neo-tree buffers											|
| <Leader>es	| Neo-tree document_symbols 						|
| <Leader>eg	| Neo-tree git_status										|
| ..					| 																			|


Index
common objects for ]/[, <leader>f/F, <leader>t/T,
| object    	| Description 						|
| ----------- | ------------------------|
| b 					| buffer									|
| c 					| console/terminal				|
| l 					| loclist									|
| q 					| quickfix								|
| t 					| tab											|
| -/+					| todo-list/todo-comments	|
| %           | unmatched group         |