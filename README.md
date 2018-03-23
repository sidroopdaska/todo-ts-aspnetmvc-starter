# Create a Todo Web App using Asp.NET Core Web API + React + Typescript

This hands-on workshop walks you through building a Single Page Application (SPA) for managing a list of "to-do" items. The project will cover:
* Building a *Web API* using Asp.NET Core
* *Storing the data* in an in-memory databse and leveraging the Microsoft Entity Framework for database operations
* Developing the User Interface using React, a popular client-side view library, and,
* Bundling the client code using Webpack, a module bundler

## Overview

The diagram below shows basic design of the app.

TODO 

A *model* is an object that represents the data in the app. In this case, the only model is a to-do item. Models are represented as C# classes, also know as Plain Old C# Object (POCOs).

A *controller* is an object that handles HTTP requests and creates the HTTP response. This app has a single controller.

To keep the tutorial simple, the app doesn't use a persistent database. Instead, the sample app stores to-do items in an in-memory database.

## Prerequisites

* Asp.NET Core SDK (https://www.microsoft.com/net/download/macos)
* Visual Studio 2017 (https://www.microsoft.com/net/download/macos)
* Node.js (https://nodejs.org/en/, download the LTS version)

## Download the Starter Kit

Download the boilerplate code by cloning the repository located at: TODO

(discuss the project structure)

Launch the app as follows:
* Navigate to the ```Website/``` folder in your terminal and run the following command ```npm start```. This should trigger Webpack which bundles your client side application into a singular bundle. Moreover, this script also invokes Webpack in *watch* mode, i.e. any future changes to your client-side source files will re-trigger the bundling process.

* Open the ```Todo.sln``` in Visual Studio and hit ```Ctrl + F5``` for Windows or Run > Start with Debugging for Mac to launch the website.

You should see TODO

## Add a model class

A model is an object that represents the data in the app. In this case, the only model is a to-do item.

Add a folder named "Models". In Solution Explorer, right-click the project. Select **Add > New Folder**. Name the folder *Models*.

Note: The model classes go anywhere in the project. The Models folder is used by convention for model classes.

Add a ```TodoItem``` class. Right-click the Models folder and select **Add > Class**. Name the class ```TodoItem``` and select **Add**.

Update the ```TodoItem``` class with the following code:

```
namespace Todo.Models
{
    public class TodoItem
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public bool IsComplete { get; set; }
    }
}
```

Note: The database automatically generates the ```Id``` when a ```TodoItem``` is created.

## Create the database context
 
The database context is the main class that coordinates Entity Framework functionality for a given data model. This class is created by deriving from the ```Microsoft.EntityFrameworkCore.DbContext``` class.

Add a ```TodoDbContext``` class. Right-click the ```Models``` folder and select **Add > Class**. Name the class ```TodoDbContext``` and select **Add**.

Replace the class with the following code:

```
using Microsoft.EntityFrameworkCore;

namespace Todo.Models
{
    public class TodoDbContext : DbContext
    {
        public TodoDbContext(DbContextOptions<TodoDbContext> options)
            : base(options)
        {
        }

        public DbSet<TodoItem> TodoItems { get; set; }

    }
}
```






