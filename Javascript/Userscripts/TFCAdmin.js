// ==UserScript==
// @name         TFC Admin Overhaul
// @namespace    http://tampermonkey.net/
// @version      0.0.2
// @description  try to take over the world!
// @author       https://github.com/johnnyedev/
// @match        https://app.terraform.io/app/admin/organizations/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=terraform.io
// @grant        GM_addStyle
// ==/UserScript==

setTimeout(function() {

    // Update Org Email to reflect as the creator email
    var creationElement = document.getElementById("ember49");
    var creationEmail = document.getElementById("ember49").innerHTML;
    creationElement.innerHTML = "Org Creator: " + creationEmail;

    const url = new URL(window.location.href);
    let theORGNAME = url.pathname.split('/')[4];

    // Update Org Name to also reflect as the numerical Org ID
    var orgNamePlace = document.getElementById("ember48")
    var orgName = document.getElementById("ember48").innerHTML
    const data = fetch(`https://app.terraform.io/api/v2/admin/sql-runner?query=SELECT%20id%20FROM%20organizations%20WHERE%20name%20%3D%20%27${theORGNAME}%27%20LIMIT%201`)
    .then((response) => response.json())
    .then((user) => {
        return user;
    });
    const outputVal = () => {
        data.then((a) => {
            console.log(a.data[0].attributes.id);
            var orgNUMID = a.data[0].attributes.id
            orgNamePlace.innerHTML = orgName + ' ' + orgNUMID;
        });
    };
   outputVal()
   console.log("this is the Org: " + theORGNAME + " This is the OrgID: " + outputVal() )



}, 900);
