# Create a Todo Web App using Asp.NET Core Web API + React + Typescript

This hands-on workshop walks you through building a Single Page Application (SPA) for managing a list of "to-do" items. The project will cover:
* Building a *Web API* using Asp.NET Core
* *Storing the data* in an in-memory databse by leveraging the Microsoft Entity Framework for database operations
* Developing the User Interface using React, a popular client-side view library, and,
* Bundling the client code using Webpack, a module bundler

## Overview

The diagram below shows basic design of the app.

<img src='readme_images/app-arch.png' width=500 /> 

A *model* is an object that represents the data in the app. In this case, the only model is a to-do item. Models are represented as C# classes, also know as Plain Old C# Object (POCOs).

A *controller* is an object that handles HTTP requests and creates the HTTP response. This app has a single controller.

To keep the tutorial simple, the app doesn't use a persistent database. Instead, the sample app stores to-do items in an in-memory database.

## Prerequisites

* Asp.NET Core SDK (https://www.microsoft.com/net/download/macos)
* Visual Studio 2017 (https://www.microsoft.com/net/download/macos)
* Node.js (https://nodejs.org/en/, download the LTS version)

## Download the Starter Kit

Download the boilerplate code by cloning the [todo-ts-aspnetmvc-starter](https://github.com/sidroopdaska/todo-ts-aspnetmvc-starter) repository 

(discuss the project structure)

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

Add a folder named "Repositories". In Solution Explorer, right-click the project. Select **Add > New Folder**. Name the folder *Repositories*.

Add a ```TodoDbContext``` class. Right-click the ```Repositories``` folder and select **Add > Class**. Name the class ```TodoDbContext``` and select **Add**.

Replace the class with the following code:

```
using Microsoft.EntityFrameworkCore;
using Todo.Models;

namespace Todo.Repositories
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

## Register the Database Context

In this step, the database context is registered with the [dependency injection](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection) container. Services (such as the DB context) that are registered with the dependency injection (DI) container are available to the controllers.

Register the DB context with the service container using the built-in support for dependency injection. Replace the contents of the ```Startup.cs``` file with the following:

```
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Todo.Repositories;

namespace Todo
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
	    services.AddDbContext<TodoDbContext>(opt => opt.UseInMemoryDatabase("TodoList"));
	    services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

	    app.UseMvc();
        }
    }
}
```

## Add a controller

A *controller* is an object that handles HTTP requests and creates the HTTP response. This app has a single controller.

Add a folder named "Controllers". In Solution Explorer, right-click the project. Select **Add > New Folder**. Name the folder *Controllers*.

Add a ```TodoController``` class. Right-click the ```Controllers``` folder and select **Add > Web API Controller Class**. Name the class ```TodoController``` and select **Add**.

Replace the class with the following code:

```
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Todo.Models;
using System.Linq;
using Todo.Repositories;

namespace Todo.Controllers
{
    [Route("api/[controller]")]
    public class TodoController : Controller
    {
        private readonly TodoDbContext _context;

        public TodoController(TodoDbContext context)
        {
            _context = context;

            if (_context.TodoItems.Count() == 0)
            {
                _context.TodoItems.Add(new TodoItem { Name = "Attend the Microsoft Workshop @ SISTEM" });
                _context.SaveChanges();
            }
        }       
    }
}

```

The code snippet above:
* Defines an empty controller class. In the next sections, methods are added to implement the API.
* The constructor uses Dependency Injection to inject the database context (TodoDbContext) into the controller. The database context is used in each of the CRUD methods in the controller.
* The constructor adds an item to the in-memory database if one doesn't exist.

## Getting the items

To get the to-do items, add the following methods to the ```TodoController``` class.

```
[HttpGet]
public IEnumerable<TodoItem> GetAll()
{
    return _context.TodoItems.ToList();
}

[HttpGet("{id}", Name = "GetTodo")]
public IActionResult GetById(long id)
{
    var item = _context.TodoItems.FirstOrDefault(t => t.Id == id);
    if (item == null)
    {
        return NotFound();
    }
    return new ObjectResult(item);
}
```

The above code snippet implements two GET methods:
* GET /api/todo
* GET /api/todo/{id}

Note:
* ```Name = "GetTodo"``` creates a named route. Named routes enable the app to create an HTTP link using the route name.
* MVC automatically serializes the object to JSON and writes the JSON into the body of the response message.

{ Explain Routing and Return Values}
{ Demo with Postman }

## Launch the app

In Visual Studio, press Ctrl + F5. Once the app has successful run, navigate to ```http://localhost:3001/api/todo```. You should see the following payload which was added to the in-memory database in the constructor of the ```TodoController```:

```
[
  {
    "id": 1,
    "name": "Attend Microsoft Workshop ",
    "isComplete": false
  }
]
```

## Other CRUD methods

In the following sections, ```Create```, ```Update```, and ```Delete``` methods are added to the ```TodoController```.

### Create

Add the following ```Create``` method

```
[HttpPost]
public IActionResult Create([FromBody] TodoItem item)
{
    if (item == null)
    {
        return BadRequest();
    }

    _context.TodoItems.Add(item);
    _context.SaveChanges();

    return CreatedAtRoute("GetTodo", new { id = item.Id }, item);
}
```
{ DEMO with Postman }

### Update

Add the following ```Update``` method

```
[HttpPut("{id}")]
public IActionResult Update(long id, [FromBody] TodoItem item)
{
    if (item == null || item.Id != id)
    {
        return BadRequest();
    }

    var todo = _context.TodoItems.FirstOrDefault(t => t.Id == id);
    if (todo == null)
    {
        return NotFound();
    }

    todo.IsComplete = item.IsComplete;
    todo.Name = item.Name;

    _context.TodoItems.Update(todo);
    _context.SaveChanges();
    return new NoContentResult();
}
```

{ DEMO with Postman }

### Delete

Add the following ```Delete``` method

```
[HttpDelete("{id}")]
public IActionResult Delete(long id)
{
    var todo = _context.TodoItems.FirstOrDefault(t => t.Id == id);
    if (todo == null)
    {
        return NotFound();
    }

    _context.TodoItems.Remove(todo);
    _context.SaveChanges();
    return new NoContentResult();
}
```

{ DEMO with Postman }

## Create React app container

Having successfully set up the backend services for our Todo SPA, it's time to move our focus to creating the UI for our web app.

As a first step, we will create a "container" view that will host our React application. This *container* view comprises of a templated HTML layout created using Asp.NET Core Web MVC.

To realise this, we need to perform the following:

### 1. Add an MVC controller

Add a ```HomeController``` class. Right-click the ```Controllers``` folder and select **Add > MVC Controller Class**. Name the class ```HomeController``` and select **Add**.

Add the following code snippet in the generated controller template:

```
using Microsoft.AspNetCore.Mvc;

namespace Todo.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
```

### 2. Add the corresponding View

After the creation of HomeController > Index (Action) we need to create the corresponding View to support it.

Create a ```Home``` folder under ```Views```. Within the ```Home``` folder, add an ```index.cshtml``` Razor file by right-clicking on the Home folder and selecting **Add > Razor page**

Add the following code snippet to the generated Razor page:

```
@{
    ViewData["Title"] = "Todo App";
}

<div id="react-app">Loading...</div>
```
 
### 3. Register the routes with the MVC framework

Having now created the container page that gets served when the user navigates to our app, it's time to register our Routes with the MVC framework to ensure the page gets served correctly.

Add the following lines of code to the ```Configure``` method in ```Startup.cs```:

```
app.UseStaticFiles();
app.UseMvc(routes =>
{
    routes.MapRoute(
        name: "default",
        template: "{controller=Home}/{action=Index}/{id?}");

    routes.MapSpaFallbackRoute(
        name: "spa-fallback",
        defaults: new { controller = "Home", action = "Index" });
});
```

## Build the React App

### Create the Singleton API Client

### Create the CRUD API functions

### Add some styling

## Launch the app

* Navigate to the ```Website/``` folder in your terminal. Run:
  * ```npm install``` to import the required node modoules.
  * Following this, execute the npm build script by running```npm start``` in the terminal. This should trigger Webpack which bundles your client side application into a single bundle. Moreover, this script also invokes Webpack in *watch* mode, i.e. any future changes to your client-side source files will re-trigger the bundling process.

* Next, open the ```Todo.sln``` in Visual Studio and hit ```Ctrl + F5``` for Windows or ```Run > Start with Debugging``` for Mac to launch the website.

You should see the browser navigate to ```http://localhost:3001```

**Yay!**



