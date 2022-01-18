.short-input {
  width: 25px;
  text-align: center;
}

.long-input {
  width: 120px;
}

.wide-input {
	width: 50%;
}

.checkbox {
  width: 10px;

}

.big-checkbox {
  width: 15px;
  height: 15px;
  vertical-align: middle;
  
}

input {
  padding: 2px;
  margin: 3px;
  margin-left: 5px;
  width: 60px;
}

label {
  margin: 5px;
  padding: 5px;
}

.hr-short {
  width: 75%;
  text-align: left;
  
}

.hr-fat {
  margin-top: 1.5em;
  margin-bottom: 1.5em;
  height: 2px;
  background-color: gray;
}

.button {
  width: auto;
}

div.attack-container {
  width: 650px;
  margin: auto;
  border: 1px solid #000000;
  

}

div.roll-container {
  padding: 3px;
  
}

div {
  padding: 1px;
}


/* Style the tab */
.tab {
  overflow: hidden;
  border: 1px solid #ccc;

}

/* Style the buttons that are used to open the tab content */
.tab button {
  background-color: inherit;
  float: left;
  border: none;
  outline: none;
  cursor: pointer;
  padding: 14px 16px;
  transition: 0.3s;
}

/* Change background color of buttons on hover */
.tab button:hover {
  background-color: #ddd;
}

/* Create an active/current tablink class */
.tab button.active {
  background-color: #ccc;
}

/* Style the tab content */
.tabcontent {
  display: none;
  padding: 6px 12px;
  border: 1px solid #ccc;
  border-top: none;
}

.right {
	float: right;
}

.left {
	float: left;
}

.red-button {
  background-color: red; 
  color: white; 
  border-top-color: #c23300; 
  border-left-color: #c23300; 
  border-radius: 4px
}

.grid-container {
  display: grid;
  grid-template-columns: auto 80px auto;
  grid-gap: 5px;

  padding: 10px;
}

.grid-header {
  grid-column: 1 / span 3;
  font-size: 30px;
  text-align: center;
}

.grid-footer {
  grid-column: 1 / span 3;
  font-size: 15px;
  text-align: center;
}

.grid-item1 {
  grid-column: 1;
  text-align: right;
}

.grid-item2 {
  grid-column: 2;
  text-align: center;
}

.grid-item3 {
  grid-column: 3;
  text-align: left;
}

.grid-item12 {
  grid-column: 1 / span 2;
 
  text-align: right;
}

.grid-item23 {
  grid-column: 2 / span 2;
  text-align: left;
}

.grid-item1, .grid-item2, .grid-item3, .grid-item12, .grid-item23 {
  font-size: 20px; 
}

.warning-label {
	font-style: italic;
	color: red;
}
.debug {
	border: solid green 3px
}
