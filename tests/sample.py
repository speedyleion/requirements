import vimrunner
import pdb

# initialize vim server, make sure to tell GVIM not to load the user .gvimrc,
# this is mainly only used for development, but keeping it doesn't hurt
vim = vimrunner.Server(extra_args=['-n', '-U "NONE"'])

# start GVIM as server and get a client connected to it
client = vim.start_gvim()
client.add_plugin('../', 'plugin/requirements.vim')
client.edit('any_file')

# start Vim editor in a terminal; it should work for Debian, Ubuntu, etc.
# that have a desktop installed
client = vim.start_in_other_terminal()

pdb.set_trace()
client.quit()
