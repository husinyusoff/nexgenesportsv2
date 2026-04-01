# Role and Objective
You are an expert full-stack Java web developer and UI/UX engineer. Your objective is to execute "Phase 1: Game Management" of a system simplification and UI standardization project for a Java Servlet/JSP web application called NexGen Esports.
# Overall Context
The application uses a standard MVC architecture (View (JSP) -> Controller (Servlet) -> Service -> DAO -> MySQL). 
We are undertaking a system-wide effort to:
1. Standardize UI by ensuring all pages have proper HTML boilerplate, sidebar layouts, and consistent CSS.
2. Simplify the backend by merging unnecessary DAO interfaces directly into their implementation classes.
# Phase 1 Tasks
Please execute the following 5 tasks precisely:
## 1. Update CSS (`[PATH_TO_WEBAPP]/styles.css`)
We need a robust, reusable table style that can be applied to data tables across the system (including the game list and future booking/station pages).
- Add a new CSS class called `.stations-table` (or choose a more generic name like `.data-table` if you prefer, but ensure you use it consistently).
- The table style should look [DESCRIBE DESIRED STYLE: e.g., modern, clean, with a blue (#38b6ff) header background, white text on the header, light gray alternating rows, and subtle borders].
- Ensure cells have adequate padding (e.g., `10px 15px`) and the table spans 100% width.
## 2. Refactor `gameList.jsp` (`[PATH_TO_WEBAPP]/gameList.jsp`)
- Wrap the file in proper HTML5 boilerplate (`<!DOCTYPE html>`, `<html>`, `<head>`, `<body>`).
- Ensure it properly includes `header.jsp` and `sidebar.jsp` using `<jsp:include page="..." />`.
- Implement the standard layout wrapper:
  ```html
  <div class="container" style="display:flex;">
      <div class="sidebar"> <!-- sidebar include here --> </div>
      <div class="content"> <!-- page content here --> </div>
  </div>
Apply the newly created CSS table class (e.g., class="stations-table") to the data table displaying the games.
Ensure all action buttons (Edit, Delete, New Game) use existing standard button classes (e.g., .button .blue-button, .green-button, .red-button).
## 3. Refactor gameDetails.jsp ([PATH_TO_WEBAPP]/gameDetails.jsp)
Apply the exact same HTML5 boilerplate and .container > .sidebar / .content layout structure as described in Task 2.
Format the game details cleanly. Consider using a visually appealing definition list (<dl>), standard table, or a flexbox card layout instead of plain <p> tags.
Ensure buttons (Edit, Delete, Back) use the standard button classes and are aligned properly.
## 4. Refactor gameForm.jsp ([PATH_TO_WEBAPP]/gameForm.jsp)
Apply the same HTML5 boilerplate and layout structure as described in Task 2.
Style the form layout cleanly. Ensure labels are clearly associated with inputs. Use standard spacing (e.g., wrapping inputs in a <div class="form-group">).
Ensure the submit and cancel buttons use standard button classes.
## 5. Simplify Layer: Merge GameDao.java into GameDaoImpl.java
Path to Interface: [PATH_TO_JAVA]/dao/programTournament/GameDao.java
Path to Impl: [PATH_TO_JAVA]/dao/programTournament/GameDaoImpl.java
Action: Since we only have one implementation, having a separate interface is unnecessary boilerplate.
Rename GameDaoImpl.java to GameDao.java (or move the method signatures from the interface to the class and drop the extends/implements).
The new combined class should be a concrete implementation named GameDao.
Delete the old interface file.
Update GameService.java ([PATH_TO_JAVA]/service/programTournament/GameService.java) to depend directly on the new concrete GameDao class instead of the interface.
Constraints and Rules
Formatting: Do not change the core backend logic in the Servlets or JSPs; focus strictly on HTML structure and CSS class application, unless modifying the DAO layer as requested.
Review: After completing these edits, summarize exactly which files were changed, deleted, and created.
Execution: Proceed to make these file changes directly using your code editing tools.