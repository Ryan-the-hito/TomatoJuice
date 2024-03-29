
# User Customization 
title = "Tomato Memo"
title_font_size = 20
task_font_size = 12
left = 735
top = 220
screen_width = 315
screen_height = 315
bulletPoint = "∆" # This is the symbol used as a trailing point for all tasks 
max_tasks = 10 # How many tasks would you like to add to the list
refreshFrequency: 1*60000 # 60000 means 1 minute, you can choose how fast it should update its content. Faster update will drain battery faster

# ------------------------------------------------------------------

# DO NOT TOUCH (unless you know what you're doing)

root = exports ? this
root.tasks = []
root.taskList = []
root.readingFile = true

todolistfile = "./.todo.txt" # File names that start with '.' are hidden files 
tomatofile = "./.totomato.txt"

standardizeTasks: () ->
  if (root.readingFile)
    promise = @run "cat #{todolistfile}"

    # Read the external file and add the elements to the list 
    promise.then (result) ->
      taskList = result.split("\n")
      root.tasks = taskList
      root.tasks.pop()
      root.taskList = []
      root.taskList.push ("#{bulletPoint} " + i) for i in root.tasks

    root.readingFile = false
    return root.taskList
  else 
    root.taskList = []
    root.taskList.push ("#{bulletPoint} " + i) for i in root.tasks
    return root.taskList
  
updateText: (number, tasks, newContent) ->
  console.log(number)
  if (tasks[number] != undefined)
    $(newContent).find('.task' + (number + 1)).text(tasks[number])
  else 
    $(newContent).find('.task' + (number + 1)).text("")

afterRender: (newContent) ->
  # # Open the text file containing the tasks (click on the title)
  # $(newContent).find(".txt-title").on 'click', =>
  #   @run "open #{todolistfile}"

  # Delete a task 
  $(newContent).find(".txt-task").on 'click', (event) => 
    taskText = event.target.textContent
    taskText = taskText.slice(bulletPoint.length + 1)
    root.tasks = root.tasks.filter (word) -> word isnt taskText

    # Save the file 
    content = ""
    content = content + i + "\n" for i in root.tasks
    console.log(content)
    @run "echo -n \"#{content}\" \> #{todolistfile}"

  # Add a new task 
  $(newContent).find(".addBtn").on 'click', => 

    # Get the value of the task that was typed in 
    newTaskText = document.getElementById("myInput").value
    document.getElementById("myInput").value = ""

    # Add the task to the task list if there are at most 9 tasks currently 
    if newTaskText != "" && root.tasks.length < max_tasks
      root.tasks.push(newTaskText)

      # Save the file 
      content = ""
      content = content + i + "\n" for i in root.tasks
      console.log(content)
      @run "echo -n \"#{content}\" \> #{todolistfile}"
    
  # Move all tasks
  $(newContent).find(".toBtn").on 'click', => 

    # Save the file
    content = ""
    content = content + i for i in root.tasks
    if content != "" && root.tasks.length <= max_tasks
      content = ""
      content = content + i + "\n" for i in root.tasks
      console.log(content)
      @run "echo -n \"#{content}\" > #{tomatofile}"

      # Clear tasks
      root.tasks = []

      # Save the file 
      content = ""
      console.log(content)
      @run "echo -n \"#{content}\" > #{todolistfile}"

update: (output, newContent) ->
  tasks = @standardizeTasks()

  $(newContent).find('.txt-title').text("- " + title + " -") 

  @updateText(i, tasks, newContent) for i in [0..(max_tasks - 1)]

style: """

  @font-face {
    font-family: Anurati;
    src: url("Anurati.otf") format("opentype");
  }

  color: #000
  font-color: #ca9991
  top: #{top}px
  left: #{left}px
  font-family: Helvetica, sans-serif
  font-size: 10px
  line-height: 1
  opacity: 1
  //text-transform: uppercase
  //transform: translate(-50%, -50%)

  .container
    text-align: left
    display: block
    width: #{screen_width}px
    height: #{screen_height}px
    overflow: hidden
    background-color: rgba(white, 1)
    padding: 15px
    border-radius: 20px;

  .txt-task
    line-height: 2
    font-size: #{task_font_size}px
    color: #000000
    user-select: none;
    cursor: pointer;
    transition: 0.3s;

  .txt-task:hover {
    background-color: rgba(0, 0, 0, 0.3);
  }

  .txt-title
    text-align: center
    line-height: 1
    font-size: #{title_font_size}px
    color: #000000
    user-select: none;
    cursor: default;
    
  input {
    margin-top: 5px;
    padding: 3px;
    padding-left: 6px;
    border: none;
    border-radius: 10px;
    font-size: 10px;
    width: 40%;
    float: left;
    background-color: rgba(0, 0, 0, 0.3);
    color: rgba(black, 0.5);
  }

  .addBtn {
    margin-top: 5px;
    margin-left: 5%;
    padding: 4px;
    border: none;
    border-radius: 10px;
    width: 20%;
    font-size: 10px;
    color: rgba(255, 255, 255, 0.5);
    float: left;
    text-align: center;
    cursor: pointer;
    transition: 0.3s;
    background-color: rgba(0, 0, 0, 0.3);
    user-select: none;
  }

  .addBtn:hover {
    background-color: rgba(0, 0, 0, 0.7);
  }

  .toBtn {
    margin-top: 5px;
    margin-left: 5%;
    padding: 4px;
    border: none;
    border-radius: 10px;
    width: 20%;
    font-size: 10px;
    color: rgba(255, 255, 255, 0.5);
    float: left;
    text-align: center;
    cursor: pointer;
    transition: 0.3s;
    background-color: rgba(0, 0, 0, 0.3);
    user-select: none;
  }

  .toBtn:hover {
    background-color: rgba(0, 0, 0, 0.7);
  }
"""


render: () -> """
  <div class='container'>
    <div class='txt-title'>
      <span class="title">Text</span>
    </div>
    <hr style="border: 0; height: 2px; background-color: #000000; user-select: none;">
    <div class='txt-task task1'></div>
    <div class='txt-task task2'></div>
    <div class='txt-task task3'></div>
    <div class='txt-task task4'></div>
    <div class='txt-task task5'></div>
    <div class='txt-task task6'></div>
    <div class='txt-task task7'></div>
    <div class='txt-task task8'></div>
    <div class='txt-task task9'></div>
    <div class='txt-task task10'></div>
    <div class='txt-task task11'></div>
    <div class='txt-task task12'></div>
    <div class='txt-task task13'></div>
    <div class='txt-task task14'></div>
    <div class='txt-task task15'></div>
    <div class='txt-task task16'></div>
    <div class='txt-task task17'></div>
    <div class='txt-task task18'></div>
    <div class='txt-task task19'></div>
    <div class='txt-task task20'></div>
    <div class='txt-task task21'></div>
    <div class='txt-task task22'></div>
    <div class='txt-task task23'></div>
    <div class='txt-task task24'></div>
    <div class='txt-task task25'></div>
     <div class='add-container'> 
        <input type="text" id="myInput" placeholder="New Task..."><span class="addBtn" id="addBtnID">Add</span><span class="toBtn" id="toBtnID">To 🍅</span>
     </div>
  </div>
"""