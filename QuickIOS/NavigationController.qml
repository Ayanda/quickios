/*
 NavigationController provides views management like UINavigationController in iOS

  Author: Ben Lau (benlau)
  License: Apache License
  Project: https://github.com/hilarycheng/quickios

 */

import QtQuick 2.2
import "./priv"

ViewController {
    id : navigationController

    /// The instance of NavigationBar
    property alias navigationBar : navBar

    /* The first view that should be shown when the NavigationController is created.
       It should be an object. Component and string source is not allowed. It is
       just a convenience for writing Component.onCompleted: push()

       Moreover, don't change the value after created or your have pushed any view already.
     */
    property alias initialViewController : stack.initialViewController

    property var topViewController : null

    property var viewControllers : new Array
//    property alias views : stack.views

    // Create ViewController from source file or Component then push it into the stack.
    function push(source,options) {
        // Just like the present() and presentViewController() in ViewController. QuickIOS offer a solution
        // that will create the component for you. Those functions will not has suffix of "viewController"
        stack.push(source,options);
    }

    function pop() {
        stack.pop();
    }

    NavigationBar {
        id : navBar
        views: stack.views
        tintColor: navigationController.tintColor
        onBackClicked: stack.pop(true);
        z: stack.z + 1
    }

    NavigationStack {
        id : stack
        anchors.top: navBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        tintColor : navigationController.tintColor

        onPushed: {
            // Attach navigationController to a newly created view
            if (view.hasOwnProperty("navigationController"))
                view.navigationController = navigationController;

            topViewController = view;
            viewControllers.push(view);
            navigationController.viewControllersChanged();
        }

        onPoped: {
            var view = null;
            if (views.count > 0) {
                view = views.get(views.count - 1).object;
            }
            viewControllers.splice(viewControllers.length - 1 , 1);
            navigationController.viewControllersChanged();

            topViewController = view;
        }
    }

}
