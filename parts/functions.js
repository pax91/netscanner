function toggle(divID) {
    var item = document.getElementById(divID);
    if (item) {
    item.className=(item.className=='hidden')?'unhidden':'hidden';
    }
}           
function togglePorts(tableID,portState) {
    var table = document.getElementById(tableID);    
    var tbody = table.getElementsByTagName("tbody")[0];
    var rows = tbody.getElementsByTagName("tr");
    for (var i=0; i < rows.length; i++) {
    var value = rows[i].getElementsByTagName("td")[2].firstChild.nodeValue;
    if (value == portState) {
        rows[i].style.display = (rows[i].style.display == 'none')?'':'none';
    }
    }
}      
function toggleAll(portState) {
    var allTables = document.getElementsByTagName("table");
    for (var c=0; c < allTables.length; c++) {
    if (allTables[c].id != "") {
        togglePorts(allTables[c].id, portState)
    }
    }
}      
function init (){
    toggleAll('closed');
    toggleAll('filtered');     
}      
window.onload = init; 