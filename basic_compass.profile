<?php
// $Id$

/**
 * Return an array of the modules to be enabled when this profile is installed.
 *
 * @return
 * An array of modules to enable.
 */
function basic_compass_profile_modules() {
  return array(
    // required core modules
    'block', 'filter', 'node', 'system', 'user',

    // optional core modules
    'dblog', 'comment', 'contact', 'help', 'menu', 'path', 'taxonomy',
    'trigger', 'filter', 'openid', 'php', 'update',
    
    // development
    'devel', 'compass',
    
    // admin
    'admin',
    
    );
}

/**
 * Return a description of the profile for the initial installation screen.
 *
 * @return
 * An array with keys 'name' and 'description' describing this profile,
 * and optional 'language' to override the language selection for
 * language-specific profiles.
 */
function basic_compass_profile_details() {
  return array(
    'name' => 'The Jibe - Basic/Compass profile',
    'description' => 'Example install profile for Basic & Compass integration. Read <a href="http://thejibe.com/blog/11/1/getting-started-basic-sass-and-compass-drupal">the blog post</a> for more information.'
  );
}

/**
 * Return a list of tasks that this profile supports.
 *
 * @return
 * A keyed array of tasks the profile will perform during
 * the final stage. The keys of the array will be used internally,
 * while the values will be displayed to the user in the installer
 * task list.
 */
function basic_compass_profile_task_list() {
}

/**
 * Perform any final installation tasks for this profile.
 *
 * The installer goes through the profile-select -> locale-select
 * -> requirements -> database -> profile-install-batch
 * -> locale-initial-batch -> configure -> locale-remaining-batch
 * -> finished -> done tasks, in this order, if you don't implement
 * this function in your profile.
 *
 * If this function is implemented, you can have any number of
 * custom tasks to perform after 'configure', implementing a state
 * machine here to walk the user through those tasks. First time,
 * this function gets called with $task set to 'profile', and you
 * can advance to further tasks by setting $task to your tasks'
 * identifiers, used as array keys in the hook_profile_task_list()
 * above. You must avoid the reserved tasks listed in
 * install_reserved_tasks(). If you implement your custom tasks,
 * this function will get called in every HTTP request (for form
 * processing, printing your information screens and so on) until
 * you advance to the 'profile-finished' task, with which you
 * hand control back to the installer. Each custom page you
 * return needs to provide a way to continue, such as a form
 * submission or a link. You should also set custom page titles.
 *
 * You should define the list of custom tasks you implement by
 * returning an array of them in hook_profile_task_list(), as these
 * show up in the list of tasks on the installer user interface.
 *
 * Remember that the user will be able to reload the pages multiple
 * times, so you might want to use variable_set() and variable_get()
 * to remember your data and control further processing, if $task
 * is insufficient. Should a profile want to display a form here,
 * it can; the form should set '#redirect' to FALSE, and rely on
 * an action in the submit handler, such as variable_set(), to
 * detect submission and proceed to further tasks. See the configuration
 * form handling code in install_tasks() for an example.
 *
 * Important: Any temporary variables should be removed using
 * variable_del() before advancing to the 'profile-finished' phase.
 *
 * @param $task
 * The current $task of the install system. When hook_profile_tasks()
 * is first called, this is 'profile'.
 * @param $url
 * Complete URL to be used for a link or form action on a custom page,
 * if providing any, to allow the user to proceed with the installation.
 *
 * @return
 * An optional HTML string to display to the user. Only used if you
 * modify the $task, otherwise discarded.
 */
function basic_compass_profile_tasks(&$task, $url) {

  // Insert default user-defined node types into the database. For a complete
  // list of available node type attributes, refer to the node type API
  // documentation at: http://api.drupal.org/api/HEAD/function/hook_node_info.
  $types = array(
    array(
      'type' => 'page',
      'name' => st('Page'),
      'module' => 'node',
      'description' => st("A <em>page</em>, similar in form to a <em>story</em>, is a simple method for creating and displaying information that rarely changes, such as an \"About us\" section of a website. By default, a <em>page</em> entry does not allow visitor comments and is not featured on the site's initial home page."),
      'custom' => TRUE,
      'modified' => TRUE,
      'locked' => FALSE,
      'help' => '',
      'min_word_count' => '',
    ),
  );

  foreach ($types as $type) {
    $type = (object) _node_type_set_defaults($type);
    node_type_save($type);
  }

  // Enable admin theme.
  variable_set('admin_theme', 'rubik');

  // Set default theme.
  variable_set('theme_default', 'basic');
  
  // Set Compass defaults.
  variable_set('compass_debugging', 0);
  variable_set('compass_output_style', 'expanded');
  variable_set('compass_environment', 'development');
  variable_set('compass_devel_rebuild', 1);
  variable_set('devel_rebuild_theme_registry', 1);
  
  // Update the menu router information.
  menu_rebuild();
}

/**
 * Implementation of hook_form_alter().
 *
 * Allows the profile to alter the site-configuration form. This is
 * called through custom invocation, so $form_state is not populated.
 */
function basic_compass_form_alter(&$form, $form_state, $form_id) {
  if ($form_id == 'install_configure') {
    // Set default for site name field and admin account.
    $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
    $form['admin_account']['account']['pass']['#description'] = t('Randomly Generated Password') . ': <strong>' . createRandomPassword(10) . '</strong>';
  }
}

/**
 * Generates random Password to optionally use.
 */
function createRandomPassword($length = 8) {
  $chars = "aA1bB2cC3dD4eE5fF6gG7hH8iI9jJ0kK!lL@mM#nNoO%pP^qQ&rR&sS*tT_uU-vV+wWxXyYzZ";
  srand((double)microtime()*1000000);
  $i = 0;
  $pass = '' ;
  while ($i <= $length) {
    $num = rand() % 33;
    $tmp = substr($chars, $num, 1);
    $pass = $pass . $tmp;
    $i++;
  }
  return $pass;
}
