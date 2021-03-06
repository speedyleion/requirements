import unittest
import vimrunner
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
        # pass

    def testDefaultOpenWindow(self):
        """
        This will test the opening of the window and that it is in the correct
        location and it obeys the global variables set.
        """
        self.client.command("RequirementsOpen")
        import pdb; pdb.set_trace()  # XXX BREAKPOINT

        winnr = self.client.eval('winnr()')
        self.assertEqual(winnr, '2', "Requirements window should be the "
                         "second one")

        bufname = self.client.eval('bufname("")')

        self.assertEqual(bufname, '__Requirements__', "Expecting "
                         "`__Requirements__`; Got %s"
                         %(bufname))

        height = int(self.client.eval('winheight(0)'))
        expected_height = int(self.vim.remote_expr('g:requirements_height'))
        self.assertEqual(height, expected_height, "Expected %s, but got %s."
                         %(expected_height, height))

    def testConfiguredOpenWindow(self):
        """
        This will change the settings so that the window is on top and that the
        height is different than the default
        """
        # Change the default values
        self.client.command('let g:requirements_top=1')
        expected_height = 5
        self.client.command('let g:requirements_height=' + str(expected_height))
        self.client.command("RequirementsOpen")

        winnr = self.client.eval('winnr()')
        self.assertEqual(winnr, '1', "Requirements buffer should be the "
                         "first one")

        bufname = self.client.eval('bufname("")')

        self.assertEqual(bufname, '__Requirements__', "Expecting "
                         "`__Requirements__`; Got %s"
                         %(bufname))

        height = int(self.client.eval('winheight(0)'))
        self.assertEqual(height, expected_height, "Expected %s, but got %s."
                         %(expected_height, height))

if __name__ == '__main__':
    unittest.main()
