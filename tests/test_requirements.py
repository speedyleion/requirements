import unittest
import vimrunner
# import pdb
import os

dirname = os.path.dirname(os.path.abspath(__file__))

class TestWindowCreation(unittest.TestCase):
    """
    This is the class that tests the basic creation of the requirements window.
    This doesn't do any validation of jumping back and forth or highlighting and
    tagging the requirements, etc.
    """

    def setUp(self):
        """
        This just creates a vim server instance.
        """
        # initialize vim server, make sure to tell GVIM not to load the user
        # .gvimrc,
        self.vim = vimrunner.Server(extra_args=['-n', '-U "NONE"'])

        # start GVIM as server and get a client connected to it
        self.client = self.vim.start_gvim()
        self.client.add_plugin(dirname + '/../', 'plugin/requirements.vim')

    def tearDown(self):
        self.client.quit()

    def testOpenWindow(self):
        """
        This will test the opening of the window and that it is in the correct
        location and it obeys the global variables set.
        """
        self.client.edit('any_file')

        self.client.command("RequirementsOpen")
        bufname = self.client.eval('bufname(' + self.client.get_active_buffer()
                                   + ')')

        self.assertEqual(bufname, '__Requirements__', "Expecting "
                         "`__Requirements__`; Got %s"
                         %(bufname))


