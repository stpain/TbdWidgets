# TbdWidgets
World of warcraft UI widgets

Copy all the files intoyour world of warcraft addon and change the template and mixin prefix "TbdWidgets" to your addon project name.

You can then use the widgets in xml or lua by inheriting them

Listviews will need some key values set, i do this in xml btu should also work in lua

Dropdowns use a :SetMenu() call and require a table of items such as { { text = "", func = foo, }, }

Gridview and Listview both use :SetDataBinding() and :ResetDataBinding() for their items
