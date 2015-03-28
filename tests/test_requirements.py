import vimrunner
# import pdb
import os

dirname = os.path.dirname(os.path.abspath(__file__))

# initialize vim server, make sure to tell GVIM not to load the user .gvimrc,
vim = vimrunner.Server(extra_args=['-n', '-U "NONE"'])

# start GVIM as server and get a client connected to it
client = vim.start_gvim()
client.add_plugin(dirname + '/../', 'plugin/requirements.vim')
client.edit('any_file')

client.command("RequirementsOpen")
client.quit()
