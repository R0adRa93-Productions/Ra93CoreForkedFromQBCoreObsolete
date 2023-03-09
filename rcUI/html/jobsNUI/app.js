/* Variables */
let btnList = [];
let btnCnt = 0;
let Lang = [];
let action = "";
let dbgmsg = "";
/* Navigation */
const open = () => {
 resetMenus();
 processMainMenu();
 resetMenus();
 $("#container").fadeIn(150, () => {
  $("#mainMenuContainer").fadeIn(0, () => {
   $("#mainMenuHeader").fadeIn(0);
   $("#mainMenuContent").fadeIn(0);
  });
 });
}
const close = () => {
 let data = null;
 btnList = null;
 delete btnList;
 $("#contentContainer").removeClass("open");
 $("#subMenuContainer").removeClass("open");
 $("#container").fadeOut(150, () => {
  resetMenus();
  empty();
 });
 $.post('https://qb-jobs/closeMenu', data, function(){})
}
const emptyMainMenu = () => {
 $("#mainMenuHeaderH1").empty();
 $("#mainMenuCloseContainer").empty();
 $("#mainMenuActionButtons").empty();
 $("#mainMenuContent").empty();
}
const emptySubMenu = () => {
 $("#subMenuHeaderH1").empty();
 $("#subMenuRetractContainer").empty();
 $("#subMenuActionButtons").empty();
 $("#subMenuContent").empty();
}
const emptyContent = () => {
 $("#contentHeaderH1").empty();
 $("#contentRetractContainer").empty();
 $("#contentActionButtons").empty();
 $("#content").empty();
}
const empty = () => {
 emptyMainMenu();
 emptySubMenu();
 emptyContent();
}
const resetMenus = () => {
 $("#mainMenuContainer").fadeOut();
 $("#mainMenuHeader").hide();
 $("#mainMenuContent").hide();
/* $("#subMenuContainer").hide();
 $("#subMenuHeader").hide();
 $("#subMenuContent").hide(); */
 for(let i = 0; i <= btnCnt; i++){
  $(`#nav${i}`).hide();
  $(`#navSub${i}`).hide();
 }
}
const chooseNavDirection = (effect,btnid,element,target,targetID) => {
 closeSlideOuts(btnid)
 switch (effect) {
  case "upDown":
   menuRoutes(element,target)
  break;
  case "leftRight":
   tractMenuWindow(element,target,targetID)
  break
 }
}
const closeSlideOuts = (btnid) => {
 if(btnid == "mainMenuNavButton"){
  $("#contentContainer").removeAttr("class");
  $("#subMenuContainer").removeAttr("class");
 }
 if(btnid == "mainMenuNavSubButton"){
  $("#contentContainer").removeAttr("class");
 }
}
const traction = (element) => {
 if (element == "#subMenuContainer") {
  emptySubMenu();
  emptyContent();
  $("#contentContainer").removeAttr("class");
 }else{emptyContent();}
 $(element).removeAttr("class");
}
const tractMenuWindow = (element,target,targetID) => {
 const clearClass = () => {
  for (i = 0; i <= btnCnt; i++) {
   $(element).removeClass(`${target}${i}`);
  }
 }
 if($(element).hasClass("open") && $(element).hasClass(`${target}${targetID}`)) {
  clearClass();
  traction(element);
 }else{
  clearClass()
  $(element).addClass(`open ${target}${targetID}`);
 }
}
const menuRoutes = (element,target) => {
 if($(element).hasClass(target)) {
  $(`.${target}`).removeClass(target);
 }else{
  $(`.${target}`).slideUp();
  $(`.${target}`).removeClass(target);
 }
 $(element).toggle(target);
 $(element).addClass(target);
}
const uiManipulator = () => {
 for (const [_,v] of Object.entries(btnList.uiColors)) {
  $('head').append("<style>"+v.element+"{"+v.property+":"+v.value+";}</style>");
 }
}
const processMainMenu = () => {
 let mainMenuNavButtons = "";
 let MainMenuActionButtons = "";
 mainMenuNavButtons += `<div class="mainMenuNavButtons">`;
 let title = null;
 let personal = null;
 switch(action) {
  case "garage":
   if (!jQuery.isEmptyObject(btnList.ownedVehicles)) {
 mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.ownGarage}"></i>My Garage</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
 for (const [key] of Object.entries(btnList.ownedVehicles)) {
  mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-action="listVeh" data-selgar="ownGarage" data-vehtype="${key}" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons[key]}"></i>${key}</button></div>`;
  btnCnt++
 };
 mainMenuNavButtons += "</div></div>";
 btnCnt++;
   }
   if (!jQuery.isEmptyObject(btnList.vehicles))
   mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.jobGarage}"></i>Motorpool</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
   for (const [key] of Object.entries(btnList.vehicles)) {
 mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-action="listVeh" data-selgar="motorpool" data-vehtype="${key}" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons[key]}"></i>${key}</button></div>`;
 btnCnt++
   };
   mainMenuNavButtons += `</div></div>`;
   btnCnt++;
   if (btnList.allowPurchase && !jQuery.isEmptyObject(btnList.vehiclesForSale)) {
 mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.jobStore}"></i>Vehicle Shop</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
 for (const [key] of Object.entries(btnList.vehiclesForSale)) {
  mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-action="listVeh" data-selgar="jobStore" data-vehtype="${key}" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons[key]}"></i>${key}</button></div>`;
  btnCnt++
 };
 mainMenuNavButtons += "</div></div>";
 btnCnt++;
   }
   if(!jQuery.isEmptyObject(btnList.returnVehicle)){
 mainMenuNavButtons += `<div class="mainMenuNavButtons"><div class="mainMenuButtonItem" id="btnReturnVehicle"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-id="nav${btnCnt}" data-action="listVeh" data-vehtype="returnVehicle" data-selgar="returnVehicle" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.returnVehicle}"></i>Return Vehicles</button></div></div>`;
 btnCnt++
 btnCnt++;
   }
  break;
  case "management":
   if (!jQuery.isEmptyObject(btnList.applicants)) {
 mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.applicants}"></i>Applicants</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
 for (const [key] of Object.entries(btnList.applicants)) {
  mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="${key}"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="applicants" data-btype="manageStaff" data-citid="${key}" data-action="bossSubMenu" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.applicant}"></i>${btnList.applicants[key].personal.firstName} ${btnList.applicants[key].personal.lastName}</button></div>`;
  btnCnt++
 };
 mainMenuNavButtons += "</div></div>";
 btnCnt++;
   }
   if (!jQuery.isEmptyObject(btnList[btnList.pd.label])) {
 mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons[btnList.pd.label]}"></i>${btnList.text[btnList.pd.label]}</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
 for (const [key] of Object.entries(btnList[btnList.pd.label])) {
  if (typeof btnList[btnList.pd.label][key].personal.position !== "undefined"){
   title = `<br /> ${btnList[btnList.pd.label][key].personal.position.name}`;
   if (btnList[btnList.pd.label][key].personal.position.payRate) {
 title += ` | $${btnList[btnList.pd.label][key].personal.payRate}`;
   }
  }
  mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="${key}"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavButton" data-type="${btnList.pd.label}" data-btype="manageStaff" data-citid="${key}" data-action="bossSubMenu" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons[btnList.pd.labelSingular]}"></i>${btnList[btnList.pd.label][key].personal.firstName} ${btnList[btnList.pd.label][key].personal.lastName}${title}</button></div>`;
  btnCnt++
 };
 mainMenuNavButtons += "</div></div>";
 btnCnt++;
   }
   if (!jQuery.isEmptyObject(btnList[btnList.pd.pastLabel])) {
 mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons[btnList.pd.pastLabel]}"></i>${btnList.text[btnList.pd.pastLabel]}</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
 for (const [key] of Object.entries(btnList[btnList.pd.pastLabel])) {
  mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="${key}"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="pastMembers" data-btype="manageStaff" data-citid="${key}" data-action="bossSubMenu" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons[btnList.pd.pastLabel]}"></i>${btnList[btnList.pd.pastLabel][key].personal.firstName} ${btnList[btnList.pd.pastLabel][key].personal.lastName}</button></div>`;
  btnCnt++
 };
 mainMenuNavButtons += "</div></div>";
 btnCnt++;
   }
   if (!jQuery.isEmptyObject(btnList.deniedApplicants)) {
 mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.deniedApplicants}"></i>Denied Applicants</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
 for (const [key] of Object.entries(btnList.deniedApplicants)) {
  mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="${key}"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="deniedApplicants" data-btype="manageStaff" data-citid="${key}" data-action="bossSubMenu" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.deniedApplicant}"></i>${btnList.deniedApplicants[key].personal.firstName} ${btnList.deniedApplicants[key].personal.lastName}</button></div>`;
  btnCnt++
 };
 mainMenuNavButtons += "</div></div>";
 btnCnt++;
   }
   if (!jQuery.isEmptyObject(btnList.blacklist)) {
 mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.blacklist}"></i>Blacklist</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
 for (const [key] of Object.entries(btnList.blacklist)) {
  mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="${key}"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="blacklist" data-btype="manageStaff" data-citid="${key}" data-action="bossSubMenu" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.blacklist}"></i>${btnList.blacklist[key].personal.firstName} ${btnList.blacklist[key].personal.lastName}</button></div>`;
  btnCnt++
 };
 mainMenuNavButtons += "</div></div>";
 btnCnt++;
   }
   mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.society}"></i>Society Account</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
   btnCnt++;
   mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="sa1"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="societyManage" data-btype="manageSociety" data-action="society" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}" data-selector="deposit"><i class="${btnList.icons.societyDeposit}"></i>Make Deposit</button></div>`;
   btnCnt++;
   mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="sa2"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="societyManage" data-btype="manageSociety" data-action="society" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}" data-selector="withdrawl"><i class="${btnList.icons.societyWithdrawl}"></i>Make Withdrawl</button></div>`;
   btnCnt++;
/* Future Ready for Bank Update
   mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="sa3"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="societyHistory" data-btype="manageSociety" data-action="society" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.societyDeposit}"></i>Account History</button></div>`;
   btnCnt++;
*/
   mainMenuNavButtons += "</div></div>";
  break;
  case "multiJob":
   let status = "";
   if (!jQuery.isEmptyObject(btnList.jobs.hired)) {
 mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain whiteBG" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.hiredOn}"></i>Jobs Hired Onto</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons"><table class="mainMenuContentContainer">`;
 btnCnt++;
 for (const [key, value] of Object.entries(btnList.jobs.hired)) {
  status = `<button class="mainMenuContentButtonActivate actionButton" data-action="multiJob" data-btype="activate" data-job="${value.name}"><i class="${btnList.icons.activate}"></i>Activate</button>`
  if (value.active === true) {status = `<button class="mainMenuContentActive"><i class="${btnList.icons.active}"></i>Active</span>`}
  mainMenuNavButtons += `<tr class="mainMenuNavSubButtonItem" id="${key}"><td>${status}<br /><button class="mainMenuContentButtonQuit actionButton" data-action="multiJob" data-type="multijob" data-btype="quit" data-job="${value.name}"><i class="${btnList.icons.quit}"></i>Quit</button></td><td>${value.label}<br /><span class="position">${value.position} | ${value.currencySymbol}${value.pay}</span></td></tr>`;
 };
 mainMenuNavButtons += "</table></div></div>";
   }
   status = "";
   if (!jQuery.isEmptyObject(btnList.jobs.available)) {
 mainMenuNavButtons += `<div class="mainMenuContentItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain whiteBG" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.available}"></i>Available Jobs</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons"><table class="mainMenuContentContainer">`;
 btnCnt++;
 for (const [key, value] of Object.entries(btnList.jobs.available)) {
  status = `<button class="mainMenuContentButtonActivate actionButton" data-action="multiJob" data-type="multiJob" data-btype="apply" data-job="${value.name}"><i class="${btnList.icons.apply}"></i>Apply</button>`
  if (value.status === "pending") {status = `<button class="mainMenuContentPending"><i class="${btnList.icons.pending}"></i>Pending</button><br /><button class="mainMenuContentButtonQuit actionButton" data-action="multiJob" data-type="multijob" data-btype="rescind" data-job="${value.name}"><i class="${btnList.icons.rescind}"></i>Rescind</button>`}
  if (value.status === "blacklisted") {status = `<button class="mainMenuContentPending"><i class="${btnList.icons.blacklisted}"></i>Blacklisted</button>`}
  mainMenuNavButtons += `<tr class="mainMenuNavSubButtonItem" id="${key}"><td>${status}</td><td>${value.label}</td></tr>`;
 };
 mainMenuNavButtons += "</table></div></div>";
   }
   if (!jQuery.isEmptyObject(btnList.gangs.hired)) {
 mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain whiteBG" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.hiredOn}"></i>Gangs Jumped Into</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons"><table class="mainMenuContentContainer">`;
 btnCnt++;
 for (const [key, value] of Object.entries(btnList.gangs.hired)) {
  status = `<button class="mainMenuContentButtonActivate actionButton" data-action="multiJob" data-btype="activate" data-gang="${value.name}"><i class="${btnList.icons.activate}"></i>Activate</button>`
  if (value.active === true) {status = `<button class="mainMenuContentActive"><i class="${btnList.icons.active}"></i>Active</span>`}
  mainMenuNavButtons += `<tr class="mainMenuNavSubButtonItem" id="${key}"><td>${status}<br /><button class="mainMenuContentButtonQuit actionButton" data-action="multiJob" data-type="multijob" data-btype="quit" data-gang="${value.name}"><i class="${btnList.icons.quit}"></i>Quit</button></td><td>${value.label}<br /><span class="position">${value.position}</span></td></tr>`;
 };
 mainMenuNavButtons += "</table></div></div>";
   }
   status = "";
   if (!jQuery.isEmptyObject(btnList.gangs.available)) {
 mainMenuNavButtons += `<div class="mainMenuContentItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain whiteBG" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.available}"></i>Available Gangs</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons"><table class="mainMenuContentContainer">`;
 btnCnt++;
 for (const [key, value] of Object.entries(btnList.gangs.available)) {
  status = `<button class="mainMenuContentButtonActivate actionButton" data-action="multiJob" data-type="multiJob" data-btype="apply" data-gang="${value.name}"><i class="${btnList.icons.apply}"></i>Apply</button>`
  if (value.status === "pending") {status = `<button class="mainMenuContentPending"><i class="${btnList.icons.pending}"></i>Pending</button><br /><button class="mainMenuContentButtonQuit actionButton" data-action="multiJob" data-type="multijob" data-btype="rescind" data-gang="${value.name}"><i class="${btnList.icons.rescind}"></i>Rescind</button>`}
  if (value.status === "blacklisted") {status = `<button class="mainMenuContentPending"><i class="${btnList.icons.blacklisted}"></i>Blacklisted</button>`}
  mainMenuNavButtons += `<tr class="mainMenuNavSubButtonItem" id="${key}"><td>${status}</td><td>${value.label}</td></tr>`;
 };
 mainMenuNavButtons += "</table></div></div>";
   }
  break;
 }
 mainMenuNavButtons += `</div>`;
 emptyMainMenu();
 appendMainMenuHeader();
 $("#mainMenuContent").append(mainMenuNavButtons);
}
const processSubMenu = (data) => {
 let subMenuNavButtons = "";
 let subMenuNavSubButtons = "";
 let subMenuActionButtons = "";
 let btn = "";
 let element = "";
 let vehicles = [];
 switch(action) {
  case "garage":
   switch(data.selGar) {
 case "ownGarage":
  vehicles = btnList.ownedVehicles;
  data.header = `My Garage`;
 break;
 case "jobStore":
  vehicles = btnList.vehiclesForSale;
  data.header = `Vehicle Shop`;
 break;
 case "motorpool":
  vehicles = btnList.vehicles;
  data.header = `Motorpool`;
 break;
 case "returnVehicle":
  vehicles["returnVehicle"] = [];
  vehicles.returnVehicle = btnList.returnVehicle;
  data.header = "Return Vehicle";
 break;
   }
   subMenuNavButtons += `<div class="subMenuNavButtons">`;
   for (const [key,value] of Object.entries(vehicles[data.vehType])) {
 switch(data.selGar){
  case "returnVehicle":
   subMenuNavButtons += `<div class="subMenuNavButtonItem"><button id="${key}" class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-action="delVeh" data-plate="${key}"><i class="${btnList.icons.returnVehicle}"></i>${value.vehicle}<br />${key}</button></div>`;
  break;
  case "ownGarage":
   let btnhide = "";
   if(btnList.returnVehicle[value.plate]){
 btnhide = `style="display:none;"`;
   }
   if(value.parkingPrice){element = `<br />${value.plate}<br /><u><strong>Parking Fee</strong></u><br />$${value.parkingPrice}`}
   subMenuNavButtons += `<div class="subMenuNavButtonItem" id="btn${value.plate}" ${btnhide}><button id="${value.plate}" class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-action="selVeh" data-plate="${value.plate}" data-selgar="${data.selGar}" data-vehicle="${value.spawn}"><i class="${value.icon}"></i>${value.label}${element}</button></div>`;
  break;
  default:
   element = "";
   if (data.selGar == "jobStore") {
 if(value.purchasePrice){element = `<br /><u><strong>Purchase Price</strong></u><br />$${value.purchasePrice}`}
   }
   else if (data.selGar == "motorpool") {
 if(value.depositPrice){element += `<br /><u><strong>Refundable Deposit</strong></u><br />$${value.depositPrice}`}
 if(value.rentPrice){element += `<br /><u><strong>Rental Price</strong></u><br />$${value.rentPrice}`}
   }
   subMenuNavButtons += `<div class="subMenuNavButtonItem"><li><button id="${key}" class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-action="selVeh" data-selgar="${data.selGar}" data-vehicle="${value.spawn}"><i class="${value.icon}"></i>${value.label}${element}</button></div>`;
  break;
 }
   };
   subMenuNavButtons += "</div>"
  break;
  case "management":
   switch(data.type){
 case "applicants":
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="approve"><i class="${btnList.icons.approve}"></i>Approve</button></div>`;
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="deny"><i class="${btnList.icons.deny}"></i>Deny</button></div>`;
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="blacklist"><i class="${btnList.icons.blacklist}"></i>Blacklist</button></div>`;
 break;
 case btnList.pd.label:
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="promote"><i class="${btnList.icons.promote}"></i>Promote</button></div>`;
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="demote"><i class="${btnList.icons.demote}"></i>Demote</button></div>`;
  if (btnList.pd.type === "job") {subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-citid="${data.citid}" data-job="${btnList.jg}" data-action="bossContent" data-baction="pay" data-ctype="actionButtons" data-type="${data.type}" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.pay}"></i>Adjust Pay</button></div>`;}
  btnCnt++
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="terminate"><i class="${btnList.icons.fire}"></i>Terminate</button></div>`;
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-citid="${data.citid}" data-job="${btnList.jg}" data-action="bossContent" data-baction="award" data-ctype="actionButtons" data-type="${data.type}" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.award}"></i>Award</button></div>`;
  btnCnt++
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-citid="${data.citid}" data-job="${btnList.jg}" data-action="bossContent" data-baction="reprimand" data-ctype="actionButtons" data-type="${data.type}" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.reprimand}"></i>Reprimand</button></div>`;
  btnCnt++
 break;
 case btnList.pd.pastLabel:
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="reconsider"><i class="${btnList.icons.reconsider}"></i>Reconsider</button></div>`;
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="blacklist"><i class="${btnList.icons.blacklist}"></i>Blacklist</button></div>`;
 break;
 case "deniedApplicants":
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="reconsider"><i class="${btnList.icons.reconsider}"></i>Reconsider</button></div>`;
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="blacklist"><i class="${btnList.icons.blacklist}"></i>Blacklist</button></div>`;
 break;
 case "blacklist":
  subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-baction="reconsider"><i class="${btnList.icons.reconsider}"></i>Reconsider</button></div>`;
 break;
 case "societyHistory":
  /* Future Proof when bank update is ready uncomment this code!
  data.header = `Society Account History`;
  subMenuNavButtons = `<div class="contentBody"><table class="deets">`;
  subMenuNavButtons += `<caption>Society Account Details</caption>`;
  subMenuNavButtons += `<tr><th>Number</th><th>Type</th><th>Description</th></tr>`
  $.each(btnList.society.accountHistory,(k,v) => {
   subMenuNavButtons += `<tr><td>${k}</td><td>${v.type}</td><td>${v.description}</td></tr>`;
  });
  subMenuNavButtons += `</table></div>`;
  */
 break;
 case "societyManage":
  data.header = `${data.btnTitle}`;
  subMenuNavButtons = `<div class="subMenuContentBody"><table class="deets">`
  subMenuNavButtons += `<caption>Society Account</caption>`;
  subMenuNavButtons += `<tr><th>Balance:</th><td>${btnList.society.balance}</td></tr>`
  subMenuNavButtons += `</table>`;
  subMenuNavButtons += `<form method="post" class="societyForm">`;
  subMenuNavButtons += `${btnList.config.currencySymbol}<input type="number" name="depwit" value="0" class="formInput" /><br />`;
  subMenuNavButtons += `<input type="hidden" name="selector" value="${data.selector}" /><br />`;
  subMenuNavButtons += `<input type="reset" name="reset" value="Reset" class="formButton" /> <input type="submit" name="submit" value="${data.btnTitle}" class="formButton" />`;
  subMenuNavButtons += `</form></div>`;
 break;
   }
   if (data.btype == "manageStaff") {
 const history = btnList[data.type][data.citid].history;
 const personal = btnList[data.type][data.citid].personal
 if(history[btnList.jg].status === "blacklisted"){subMenuNavButtons += `<h3 class="blackListed">-- DO NOT HIRE -- Blacklisted</h3>`;}
 data.header = `${personal.firstName} ${personal.lastName}`;
 subMenuNavButtons += `<div class="subMenuNavButtons">`
 btnCnt++;
 subMenuNavButtons += `<div class="subMenuNavButtonItem"><button class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-job="${btnList.jg}" data-ctype="personal" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.personal}"></i>Personal Details</button></div>`;
 btnCnt++
 subMenuNavButtons += `<div class="subMenuNavButtonItem"><button class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-job="${btnList.jg}" data-ctype="rapSheet" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.rapSheet}"></i>Rap Sheet</button></div>`;
 btnCnt++
 subMenuNavButtons += `<div class="subMenuNavButtonItem"><button class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempSub" data-effect="upDown" data-element="#navSub${btnCnt}" data-id="${btnCnt}"><i class="${btnList.icons[btnList.jg]}"></i>${btnList.jgName} Record</button><div id="navSub${btnCnt}" class="subMenuNavSubButtons">`;
 btnCnt++;
 subMenuNavButtons += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" data-btnid="subMenuNavSubButton" data-job="${btnList.jg}" data-ctype="history" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons[btnList.jg]}"></i>Stats</button></div>`;
 btnCnt++;
 subMenuNavButtons += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" data-btnid="subMenuNavSubButton" data-job="${btnList.jg}" data-ctype="awards" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons[btnList.jg]}"></i>Awards</button></div>`;
 btnCnt++;
 subMenuNavButtons += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" data-btnid="subMenuNavSubButton" data-job="${btnList.jg}" data-ctype="reprimands" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons[btnList.jg]}"></i>Reprimands</button></div>`;
 btnCnt++;
 subMenuNavButtons += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" data-job="${btnList.jg}" data-ctype="notes" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-btnid="subMenuNavSubButton" data-targetid="${btnCnt}"><i class="${btnList.icons[btnList.jg]}"></i>Notes</button></div>`;
 btnCnt++;
 subMenuNavButtons += `</div></div>`;
 if (btnList.sysconf.showGangsHistory) {
  subMenuNavButtons += `<div class="subMenuNavButtonItem"><button class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempSub" data-effect="upDown" data-element="#navSub${btnCnt}" data-id="${btnCnt}"><i class="${btnList.icons.jobHistory}"></i>${btnList.pd.type} History</button><div id="navSub${btnCnt}" class="subMenuNavSubButtons">`;
  btnCnt++;
  if(!$.isEmptyObject(history)) {
   $.each(history, function(k,v){
 if(k != btnList.jg) {
  btn += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" data-btnid="subMenuNavSubButton" data-job="${k}" data-ctype="history" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.jobHistory}"></i>${k} Stats<br />${v.status}</button></div>`;
  btnCnt++;
 }
   })
  }
  if(btn == ""){btn = `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton" data-btnid="subMenuNavSubButton">No Job History</button></div>`;}
  btnCnt++;
  subMenuNavButtons += `${btn}</div></div>`;
 }
   }
  break;
 }
 emptySubMenu();
 $("#subMenuHeaderH1").append(data.header);
 $("#subMenuRetractContainer").append(`<button class="subMenuRetractButton actionButton" data-action="retract" data-element="#subMenuContainer"><i class="${btnList.icons.retract}"></i></button>`)
 $("#subMenuActionButtons").append(subMenuActionButtons);
 $("#subMenuContent").append(subMenuNavButtons);
}
const processContent = (data) => {
 let content = "";
 let contentHeader = "";
 const personal = btnList[data.type][data.citid].personal
 const rapSheet = btnList[data.type][data.citid].rapSheet
 const history = btnList[data.type][data.citid].history[data.job]
 const awards = history.awards
 const reprimands = history.reprimands
 const details = history.details
 const jobName = btnList.jobsList[data.job]
 switch(data.ctype) {
  case "history":
   contentHeader = `${jobName}`;
   content = `<table class="stats"><caption>Stats</caption>`
   content += `<tr><th>Applied</th><th>Hired</th><th>Denied</th></tr>`;
   content += `<tr><td>${history.applycount}</td><td>${history.hiredcount}</td><td>${history.denycount}</td></tr>`
   content += `<tr><th>Quit</th><th>Fired</th><th>Grades</th></tr>`
   content += `<tr><td>${history.quitcount}</td><td>${history.firedcount}</td><td>${history.gradechangecount}</td></tr>`;
   content += `</table>`;
  break;
  case "personal":
   contentHeader = `Personal Information`;
   content = `<div class="contentBody"><table class="deets"><tr><th>First Name</th><td>${personal["firstName"]}</td></tr>`;
   content += `<tr><th>Last Name</th><td>${personal["lastName"]}</td></tr>`;
   content += `<tr><th>Phone Number</th><td>${personal["phone"]}</td></tr>`;
   content += `<tr><th>Gender</th><td>${personal["gender"]}</td></tr></table></div>`;
  break;
  case "rapSheet":
   contentHeader = `Criminal Record`;
   content = `<div class="contentBody"><table class="deets">`;
   if(!$.isEmptyObject(rapSheet)) {
 $.each(rapSheet, function(k,v){
  content += `<tr><th>${k}</th><td>${v}</td></tr>`;
 })
   }else{content += `<tr><td class="contentListItem">No Criminal Record</td></tr>`}
   content += `</table></div>`;
  break;
  case "awards":
   contentHeader = `Awards`;
   content = `<div class="contentBody"><table class="deets">`;
   if(!$.isEmptyObject(awards)) {
 $.each(awards, function(k,v){
  content += `<tr><th>${k}</th><td>${v}</td></tr>`;
 })
   }else{content += `<tr><td>No Awards Received</td></tr>`}
   content += `</table></div>`;
  break;
  case "reprimands":
   contentHeader = `Reprimands`;
   content = `<div class="contentBody"><table class="deets">`;
   if(!$.isEmptyObject(reprimands)) {
 $.each(reprimands, function(k,v){
  content += `<tr><th>${k}</th><td>${v}</td></tr>`;
 })
   }else{content += `<tr><td>No Reprimands Received</td></tr>`}
   content += `</table></div>`;
  break;
  case "notes":
   contentHeader = `Notes`;
   content = `<div class="contentBody"><table class="deets">`;
   if(!$.isEmptyObject(details)) {
 $.each(details, function(k,v){
  content += `<tr><th>${k}</th><td>${v}</td></tr>`;
 })
   }else{content += `<tr><td>No Details to Display</td></tr>`}
   content += `</table></div>`;
  break;
  case "actionButtons":
   let desc = "";
   content = `<div class="contentBody"><form method="post" class="actionForm">`;
   switch(data.action){
 case "pay":
  contentHeader = "Set Pay Rate";
  content += `$<input type="number" name="payRate" value="${btnList[btnList.pd.label][data.citid].personal.payRate}" class="formInput" /><br />`;
  content += `<input type="hidden" name="appcid" value="${data.citid}" />`;
  content += `<input type="hidden" name="jobGangType" value="${btnList.pd.jobGangType}" />`;
  content += `<input type="hidden" name="action" value="pay" />`;
 break;
 case "award":
  contentHeader = "Choose Award";
  content += `<select name="awrep" class="formSelect formInput" /><option>Select Award</option>`;
  $.each(btnList.awards,(k,v) => {
   content += `<option value="${k}" data-desc="${v.description}" class="formOption">${v.title}</option>`
   if(typeof(desc) === "undefined"){desc = v.description}
  });
  content += `</select>`;
  content += `<input type="hidden" name="appcid" value="${data.citid}" />`;
  content += `<input type="hidden" name="jobGangType" value="${btnList.pd.jobGangType}" />`;
  content += `<input type="hidden" name="action" value="award" />`;
 break;
 case "reprimand":
  contentHeader = "Choose Reprimand";
  content += `<select name="awrep" class="formSelect formInput" /><option>Select Reprimand</option>`;
  $.each(btnList.reprimands,(k,v) => {
   content += `<option value="${k}" data-desc="${v.description}" class="formOption">${v.title}</option>`
   if(typeof(desc) === "undefined"){desc = v.description};
  });
  content += `</select>`;
  content += `<input type="hidden" name="appcid" value="${data.citid}" />`;
  content += `<input type="hidden" name="jobGangType" value="${btnList.pd.jobGangType}" />`;
  content += `<input type="hidden" name="action" value="reprimand" />`;
 break;
   }
   content += `<div class="formDescription"></div>`;
   content += `<input type="reset" value="Reset" class="formButton formReset" /><input type="submit" name="submit" value="Submit" class="formButton" /></form></div>`;
  break;
 }
 emptyContent();
 $("#contentHeaderH1").append(contentHeader);
 $("#contentRetractContainer").append(`<button class="contentRetractButton actionButton" data-action="retract" data-element="#contentContainer"><i class="${btnList.icons.retract}"></i></button>`)
 $("#contentActionButtons").append(contentActionButtons);
 $("#content").append(content);
};
const appendMainMenuHeader = () => {
 $("#mainMenuHeaderH1").append(btnList.header);
 $("#mainMenuCloseContainer").append(`<button id="closeButton" class="actionButton" data-action="close"><i class="${btnList.icons.close}"></i></button>`)
};
const errorMessage = (error) => {
 v.msg += "<table>";
 $.each(error,(k,v) => {
  v.msg += `<tr><th>${k}</th><td>${v}</td>`
 });
 v.msg += "</table>";
 $(".alert").append(v.msg);
};
$(document).on("change",".formSelect", function(e){
 $(".formSelect option:selected").each(function (){
  let desc = $(this).data('desc');
  $(".formDescription").html(desc);
 })
});
$(document).on('click',".formReset", function(e){
 $(".formDescription").html("");
});
/* Main / Root Function */
$(document).ready(function(){
 window.addEventListener('message', function(event) {
  btnList = event.data.btnList;
  Lang = event.data.Lang;
  action = event.data.action;
  if(!$.isEmptyObject(btnList.uiColors)){uiManipulator();}
  appendMainMenuHeader()
  $(".draggable").draggable();
  open();
 });
});
/* Button Controls */
$(document).on('click', ".actionButton", function(e) {
 e.preventDefault();
 let data = {};
 let btnid = $(this).data('btnid');
 let effect = $(this).data('effect');
 let target = $(this).data('target');
 let targetID = $(this).data('targetid');
 let element = $(this).data('element');
 switch ($(this).data("action")){
  case "bossAction":
   data.jobGangType = btnList.pd.jobGangType;
   data.appcid = $(this).data("appcid");
   data.action = $(this).data("baction");
   data = JSON.stringify(data)
   $.post('https://qb-jobs/managementSubMenuActions', data, function(res){
 traction("#subMenuContainer");
 delete btnList;
 btnList = res.btnList;
 action = "management";
 dbgmsg = "MGMTHere";
 empty();
 appendMainMenuHeader();
 processMainMenu();
   })
  break;
  case "bossSubMenu":
   data.type = $(this).data("type"),
   data.citid = $(this).data("citid"),
   data.btype = $(this).data("btype")
   processSubMenu(data);
  break;
  case "bossContent":
   data.jobGangType = btnList.pd.jobGangType
   data.job = $(this).data("job");
   data.type = $(this).data("type"),
   data.citid = $(this).data("citid"),
   data.ctype = $(this).data("ctype")
   if($(this).data("baction") !== "undefined"){data.action = $(this).data("baction");}
   processContent(data);
  break;
  case "selVeh":
   data.garage = btnList.garage;
   data.vehicle = $(this).data('vehicle');
   data.selgar = $(this).data('selgar');
   if (data.selgar === "ownGarage") {data.plate = $(this).data('plate');}
   $.post('https://qb-jobs/selectedVehicle', JSON.stringify(data))
   close();
  break
  case "listVeh":
   data = [];
   data.vehType = $(this).data('vehtype');
   data.selGar = $(this).data('selgar');
   emptySubMenu();
   processSubMenu(data);
  break;
  case "delVeh":
   let plate = $(this).data('plate');
   if(btnList.returnVehicle[plate].selGar == "ownGarage") {
 $(`.btn${plate}`).show();
   }
   $.post('https://qb-jobs/delVeh', JSON.stringify(plate), function(result) {
 delete btnList.returnVehicle;
 btnList.returnVehicle = result;
 $(`#${plate}`).remove();
 if ($.isEmptyObject(btnList.returnVehicle)){
  traction("#subMenuContainer",false,false);
  $("#btnReturnVehicle").remove();
 }
   }, "json");
  break;
  case "navButton":
  break;
  case "society":
   data.type = $(this).data("type"),
   data.btype = $(this).data("btype"),
   data.selector = $(this).data("selector")
   data.btnTitle = "Deposit"
   if (data.selector == "withdrawl") {data.btnTitle = "Withdrawl"};
   processSubMenu(data);
  break;
  case "multiJob":
   data.jobGangType = $(this).data("type")
   if ($(this).data("job")){
 data.job = $(this).data("job");
 data.jobGangType = "Jobs";
   };
   if ($(this).data("gang")){
 data.gang = $(this).data("gang");
 data.jobGangType = "Gangs";
   };
   data.action = $(this).data("btype");
   $.post('https://qb-jobs/processMultiJob', JSON.stringify(data), function(res){
 traction("#subMenuContainer");
 delete btnList;
 btnList = res.btnList;
 action = "multiJob";
 dbgmsg = "MGMTHere";
 empty();
 appendMainMenuHeader();
 processMainMenu();
   })
  break;
  case "retract":
   element = $(this).data('element');
   traction(element);
  break;
  case "close":
   close();
  break;
 }
 if(effect != "undefined"){
  chooseNavDirection(effect,btnid,element,target,targetID)
 }
})
$(document).on("submit",".actionForm", (e) => {
 e.preventDefault();
 const formData = new FormData(e.target).entries()
 $.post('https://qb-jobs/managementSubMenuActions', JSON.stringify(Object.fromEntries(formData)), function(res){
  traction("#subMenuContainer");
  delete btnList;
  btnList = res.btnList;
  action = "management";
  dbgmsg = "MGMTHere";
  empty();
  appendMainMenuHeader();
  processMainMenu();
 })
/*
 fetch('https://qb-jobs/managementSubMenuActions', {
  method: 'POST',
  headers: {
   'Content-Type': 'application/json',
  },
  body: JSON.stringify(Object.fromEntries(formData)),
 })
 .then((response) => response.json())
 .then((data) => {
  traction("#subMenuContainer");
  delete btnList;
  btnList = res.btnList;
  action = "management";
  dbgmsg = "MGMTHere";
  empty();
  appendMainMenuHeader();
  processMainMenu();
 })
 .catch((error) => {
  console.error('Error:', error);
 });
*/
});
$(document).on("submit",".societyForm", (e) => {
 e.preventDefault();
 const formData = new FormData(e.target).entries()
 $.post('https://qb-jobs/managementSocietyActions', JSON.stringify(Object.fromEntries(formData)), function(res){
  traction("#subMenuContainer");
  delete btnList;
  btnList = res.btnList;
  action = "management";
  dbgmsg = "MGMTHere";
  empty();
  appendMainMenuHeader();
  processMainMenu();
 })
/*
 fetch('https://qb-jobs/managementSubMenuActions', {
  method: 'POST',
  headers: {
   'Content-Type': 'application/json',
  },
  body: JSON.stringify(Object.fromEntries(formData)),
 })
 .then((response) => response.json())
 .then((data) => {
  traction("#subMenuContainer");
  delete btnList;
  btnList = res.btnList;
  action = "management";
  dbgmsg = "MGMTHere";
  empty();
  appendMainMenuHeader();
  processMainMenu();
 })
 .catch((error) => {
  console.error('Error:', error);
 });
*/
});
$(document).on('keyup', function(e) {
 if(e.key == "Escape"){ close(); }
});