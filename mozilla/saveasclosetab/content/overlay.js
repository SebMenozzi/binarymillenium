/* ***** BEGIN LICENSE BLOCK *****
 *   Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is saveasclosetab.
 *
 * The Initial Developer of the Original Code is
 * binarymillenium.
 * Portions created by the Initial Developer are Copyright (C) 2009
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK ***** */

var saveasclosetab = {

  onLoad: function() {
    // initialization code
    this.initialized = true;
    this.strings = document.getElementById("saveasclosetab-strings");
    document.getElementById("contentAreaContextMenu")
            .addEventListener("popupshowing", function(e) { saveasclosetab.showSaveCloseContextMenu(e); }, false);
  },

  showSaveCloseContextMenu: function(event) {
    // show or hide the menuitem based on what the context menu is on
    // see http://kb.mozillazine.org/Adding_items_to_menus
    document.getElementById("context-saveasclosetab").hidden = !gContextMenu.onImage;
  },
  onMenuItemCommand: function(e) {
    gContextMenu.saveImage();
    gBrowser.removeCurrentTab(); 
    // these close the whole program
    //window.close() 
    //document.close()
  },


};
window.addEventListener("load", function(e) { saveasclosetab.onLoad(e); }, false);

