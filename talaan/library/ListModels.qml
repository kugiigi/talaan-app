import QtQuick 2.4
import Ubuntu.Components 1.3
//import "../library/DBUtilities.js" as DB
import "../library/DataProcess.js" as DataProcess
//import "../components"
import "ProcessFunc.js" as Process

Item {
    id: lists
    property alias modelChecklistItems: modelChecklistItems
    property alias modelCategories: modelCategories
    property alias modelChecklist: modelChecklist
    property alias modelTargets: modelTargets

    /*WorkerScript for asynch loading of models*/
    WorkerScript {
        id: workerLoaderItems
        source: "WorkerScripts/ListModelLoader.js"

        onMessage: {
            modelChecklistItems.loadingStatus = "Ready"
        }
    }

    WorkerScript {
        id: workerLoaderChecklist
        source: "WorkerScripts/ListModelLoader.js"

        onMessage: {
            modelChecklist.loadingStatus = "Ready"
        }
    }

    WorkerScript {
        id: workerLoaderTargets
        source: "WorkerScripts/ListModelLoader.js"

        onMessage: {
            modelTargets.loadingStatus = "Ready"
        }
    }

    //Checklist items list
    ListModel {
        id: modelChecklistItems
        property string loadingStatus: "Null"

        function getItems(intChecklistID, intStatus, searchText, sort) {

            var txtName
            var txtComments
            var txtStatus
            var txtPriority
            var arrResult

            loadingStatus = "Loading"

            modelChecklistItems.clear()

            arrResult = DataProcess.getDBItems(intChecklistID, intStatus,
                                               searchText, sort)

            var msg = {'result': arrResult, 'model': modelChecklistItems,'mode': 'ListItems'};
                            workerLoaderItems.sendMessage(msg);

//            for (var i = 0; i < arrResult.length; i++) {
//                txtName = arrResult[i].name
//                txtComments = arrResult[i].comments
//                txtStatus = arrResult[i].status
//                txtPriority = arrResult[i].priority
//                modelChecklistItems.append({
//                                               itemName: txtName,
//                                               comments: txtComments,
//                                               status: txtStatus,
//                                               priority: txtPriority
//                                           })
//            }
        }
        /*ListElement { name: "Orange"; details: "The orange (specifically, the sweet orange) is the fruit of the citrus species Citrus × ​sinensis in the family Rutaceae. The fruit of the Citrus sinensis is called sweet orange to distinguish it from that of the Citrus aurantium, the bitter orange. The orange is a hybrid, possibly between pomelo (Citrus maxima) and mandarin (Citrus reticulata), cultivated since ancient times.\n-\nWikipedia"}
                                        ListElement { name: "Apple"; details: "Fruit" }
                                                                                                                        ListElement { name: "Tomato"; details: "The tomato is the edible, often red fruit of the plant Solanum lycopersicum, commonly known as a tomato plant. Both the species and its use as a food originated in Mexico, and spread throughout the world following the Spanish colonization of the Americas. Its many varieties are now widely grown, sometimes in greenhouses in cooler climates. The tomato is consumed in diverse ways, including raw, as an ingredient in many dishes, sauces, salads, and drinks. While it is botanically a fruit, it is considered a vegetable for culinary purposes (as well as under U.S. customs regulations, see Nix v. Hedden), which has caused some confusion. The fruit is rich in lycopene, which may have beneficial health effects. The tomato belongs to the nightshade family (Solanaceae). The plants typically grow to 1–3 meters (3–10 ft) in height and have a weak stem that often sprawls over the ground and vines over other plants. It is a perennial in its native habitat, although often grown outdoors in temperate climates as an annual. An average common tomato weighs approximately 100 grams (4 oz).\n-\nWikipedia" }
                                                                                                                                                                                                                                                                                        ListElement { name: "Carrot"; details: "Vegetable" }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ListElement { name: "Potato"; details: "Vegetable" }*/
    }

    ListModel {
        id: modelCategories
        property bool isListOnly: false
        property string loadingStatus: "Null"


        onIsListOnlyChanged: {
            if (isListOnly) {
                appendAddNew()
            } else {
                removeAddNew()
            }
        }

        function appendAddNew() {
            modelCategories.insert(0, {
                                       categoryname: "Add new category",
                                       descr: "add new",
                                       icon: "default"
                                   })
        }

        function removeAddNew() {
            modelCategories.remove(0)
        }

        function getColor(category) {
            var i
            for (var i = 0; i < modelCategories.count; i++) {
                if (modelCategories.get(i).categoryname === category) {
                    i = modelCategories.count
                    if (modelCategories.get(i) === undefined) {
                        return "white"
                    } else {
                        return modelCategories.get(i).colorValue
                    }
                }
            }
        }

        function getCategories() {
            var txtName
            var txtDescr
            var txtColor
            var arrResult

            loadingStatus = "Loading"

            modelCategories.clear()


            arrResult = DataProcess.getDBCategories("SELECT * FROM CATEGORY")

//            var msg = {'result': arrResult, 'model': modelCategories,'mode': 'Categories', 'extra': 'Categories'};
//                            workerLoader.sendMessage(msg);

            for (var i = 0; i < arrResult.length; i++) {
                txtName = i18n.tr(arrResult[i].name)
                txtDescr = i18n.tr(arrResult[i].descr)
                txtColor = arrResult[i].icon
                modelCategories.append({
                                           categoryname: txtName,
                                           descr: txtDescr,
                                           colorValue: txtColor
                                       })
            }

            var j = 0
            var boolFound = false
            var category = "Uncategorized"

            while (j != modelCategories.count - 1 && boolFound === false) {
                boolFound = (category === modelCategories.get(j).categoryname)
                j++
//                console.log(category + "=" + modelCategories.get(
//                                j).categoryname)
            }

            if (boolFound === false) {
                modelCategories.append({
                                           categoryname: "Uncategorized",
                                           descr: "Uncategorized lists",
                                           colorValue: "white"
                                       })
            }
        }
    }

    ListModel {
        id: modelChecklist

        property string loadingStatus: "Null"

        function findChecklistIndex(id) {
            var i = 0

            for (i = 0; i <= modelChecklist.count - 1; i++) {
                if (id === modelChecklist.get(i).id) {
                    return i
                }
            }

            return -1
        }

        function updateTotal(checklistid, newTotal) {
            var index = findChecklistIndex(checklistid)

            if (index > -1) {
                modelChecklist.setProperty(index, "total", newTotal)
            }
        }

        function updateCheckedCount(checklistid, newCheckedCount) {
            var index = findChecklistIndex(checklistid)

            if (index > -1) {
                modelChecklist.setProperty(index, "completed", newCheckedCount)
            }
        }

        function removeItem(checklistid){
            var index = findChecklistIndex(checklistid)

            if (index > -1) {
                modelChecklist.remove(index,1)
            }

        }

        function getChecklists(purpose, favorite, group, filter, order, searchMode, searchCondition, searchText) {
            var txtName
            var txtDescr
            var txtCategory
            var txtCategoryColor
            var txtCreationDT
            var txtCompletionDT
            var txtStatus
            var txtWhereStatus
            var txtWhereFavorite
            var txtTargetDT
            var boolOverdue
            var arrResult
            var txtStatement
            var txtOrder
            var txtWhere = ""
            var txtGroup = ""
            var txtSelect = ""
            var txtOrderDirection = ""
            var txtHeader = ""
            var boolFavorite
            var intContinual
            var intCompleted = 0
            var intTotal = 0
            var intID
            var bindList
            var resultsData = []

            loadingStatus = "Loading"

            modelChecklist.clear()

            searchCondition = searchCondition === "" ? "=" : searchCondition

            switch (searchMode) {
            case "default":
                if (searchText !== "") {
                    //txtWhere = " WHERE (a.name LIKE '%" + searchText + "%' OR a.descr LIKE '%" + searchText + "%')"
                    txtWhere = " WHERE (a.name LIKE ? OR a.descr LIKE ?)"
                    searchText = '%' + searchText + '%'
                    bindList = [searchText, searchText]
                } else {
                    txtWhere = ""
                }

                break
            case "category":
                if (searchText !== "") {
                    txtWhere = " WHERE a.category = ?"
                    bindList = [searchText]
                } else {
                    txtWhere = ""
                }

                break
            case "creation_date":
                if (searchCondition !== null) {
                    txtWhere = " WHERE a.creation_dt " + searchCondition + "'" + searchText + "'"
                }
                break
            case "completion_date":
                if (searchCondition !== null) {
                    txtWhere = " WHERE a.completion_dt " + searchCondition + "'" + searchText + "'"
                }
                break
            case "target_date":
                if (searchCondition !== null) {
                    txtWhere = " WHERE a.target_dt " + searchCondition + "'"
                            + searchText + "' AND a.target_dt <> ''"
                }
                break
            default:
                txtWhere = ""
                break
            }

            switch (purpose) {
            case "saved":
                txtWhereStatus = "a.status = 'saved'"
                break
            case "talaan":

                if (filter === "checklist") {
                    txtWhereStatus = "a.status = 'incomplete'"
                } else if (filter === "normal") {
                    txtWhereStatus = "a.status = 'normal'"
                } else {
                    txtWhereStatus = "a.status IN ('incomplete','normal')"
                }

                break
            case "history":
                txtWhereStatus = "a.status = 'complete'"
                break
            case "all":
                txtWhereStatus = ""
                break
            default:
                txtWhereStatus = ""
                break
            }

            if (favorite) {
                txtWhereFavorite = "a.favorite = 1"
            } else {
                txtWhereFavorite = ""
            }

            if (txtWhereStatus !== "") {
                if (txtWhere === "") {
                    txtWhere = " WHERE "
                } else {
                    txtWhere = txtWhere + " AND "
                }

                txtWhere = txtWhere + txtWhereStatus
            }

            if (txtWhereFavorite !== "") {
                if (txtWhere === "") {
                    txtWhere = " WHERE "
                } else {
                    txtWhere = txtWhere + " AND "
                }

                txtWhere = txtWhere + txtWhereFavorite
            }

            if (group.search("date") !== -1) {
                order = order === "normal" ? "reverse" : "normal"
            }

            if (order === "reverse") {
                txtOrderDirection = "desc"
            } else {
                txtOrderDirection = "asc"
            }

            switch (group) {
            case "category":
                txtSelect = "SELECT a.id, a.category, (SELECT icon from category where name = a.category) as categoryColor, a.name, a.descr, a.creation_dt, a.completion_dt, a.status, a.target_dt, (CASE WHEN a.target_dt < date('now','localtime') THEN 1 ELSE 0 END) overdue, a.favorite, a.continual, count(b.name) as total, total(CASE WHEN b.status = 0 OR b.status IS NULL THEN 0 ELSE 1 END) as completed"
                txtGroup = " GROUP BY a.category, categoryColor, a.id, a.name, a.descr, a.creation_dt, a.completion_dt, a.status, a.target_dt, overdue, a.favorite, a.continual"
                txtOrder = " ORDER BY a.category " + txtOrderDirection + ", a.creation_dt"
                break
            case "creation_date":
                txtSelect = "SELECT a.id, a.creation_dt, a.category, (SELECT icon from category where name = a.category) as categoryColor, a.name, a.descr, a.completion_dt, a.status, a.target_dt, (CASE WHEN a.target_dt < date('now','localtime') THEN 1 ELSE 0 END) overdue, a.favorite, a.continual, count(b.name) as total, total(CASE WHEN b.status = 0 OR b.status IS NULL THEN 0 ELSE 1 END) as completed"
                txtGroup = " GROUP BY a.creation_dt,a.category, categoryColor, a.id,  a.name, a.descr, a.completion_dt, a.status, a.target_dt, overdue, a.favorite, a.continual"
                txtOrder = " ORDER BY a.creation_dt " + txtOrderDirection + ", a.category"
                break
            case "target_date":
                txtSelect = "SELECT a.id, a.target_dt, a.creation_dt, a.category, (SELECT icon from category where name = a.category) as categoryColor, a.name, a.descr, a.completion_dt, a.status, (CASE WHEN a.target_dt < date('now','localtime') THEN 1 ELSE 0 END) overdue, a.favorite, a.continual, count(b.name) as total, total(CASE WHEN b.status = 0 OR b.status IS NULL THEN 0 ELSE 1 END) as completed"
                txtGroup = " GROUP BY a.target_dt, a.category, categoryColor, a.id,  a.name, a.descr, a.creation_dt, a.completion_dt, a.status, overdue, a.favorite, a.continual"
                txtOrder = " ORDER BY a.target_dt " + txtOrderDirection + ", a.category"
                break
            case "completion_date":
                txtSelect = "SELECT a.id, a.completion_dt, a.category, (SELECT icon from category where name = a.category) as categoryColor, a.name, a.descr, a.creation_dt, a.status, a.target_dt, (CASE WHEN a.target_dt < date('now','localtime') THEN 1 ELSE 0 END) overdue, a.favorite, a.continual, count(b.name) as total, total(CASE WHEN b.status = 0 OR b.status IS NULL THEN 0 ELSE 1 END) as completed"
                txtGroup = " GROUP BY a.category, categoryColor, a.id,  a.name, a.descr, a.creation_dt, a.completion_dt, a.status, a.target_dt, overdue, a.favorite, a.continual"
                txtOrder = " ORDER BY a.completion_dt " + txtOrderDirection + ", a.name"
                break
            default:
                txtSelect = "SELECT a.id, a.creation_dt, a.category, (SELECT icon from category where name = a.category) as categoryColor, a.name, a.descr, a.completion_dt, a.status, a.target_dt,(CASE WHEN a.target_dt < date('now','localtime') THEN 1 ELSE 0 END) overdue, a.favorite, a.continual, count(b.name) as total, total(CASE WHEN b.status = 0 OR b.status IS NULL THEN 0 ELSE 1 END) as completed"
                txtGroup = " GROUP BY a.category, categoryColor, a.id,  a.name, a.descr, a.creation_dt, a.completion_dt, a.status, a.target_dt, overdue, a.favorite, a.continual"
                txtOrder = " ORDER BY a.name " + txtOrderDirection + ", a.creation_dt"
            }

            txtStatement = txtSelect
                    + " FROM CHECKLIST a LEFT OUTER JOIN items b ON a.id = b.checklist_id"
                    + txtWhere + txtGroup + txtOrder //ORDER BY a.category, a.creation_dt";
            //console.log(txtStatement)
            arrResult = DataProcess.getDBChecklists(txtStatement, bindList)

            var msg = {'result': arrResult, 'model': modelChecklist,'mode': 'Lists','group': group};
                            workerLoaderChecklist.sendMessage(msg);
        }
    }

    //Upcoming and overdue targets
    ListModel {
        id: modelTargets
        property string loadingStatus: "Null"

        function getTargets() {
            var txtID
            var txtName
            var txtTargetDt
            var txtHeader
            var boolOverdue
            var boolReminder
            var arrResult

            loadingStatus = "Loading"

            modelTargets.clear()

            arrResult = DataProcess.getTargets()

            var msg = {'result': arrResult, 'model': modelTargets,'mode': 'Targets'};
                            workerLoaderTargets.sendMessage(msg);

        }

        function updateOverdueStatus() {
            var modelCount
            var targetDate

            modelCount = modelTargets.count
            var today = new Date(Process.getToday())
            for (var i = 0; i < modelCount; i++) {
                targetDate = new Date(modelTargets.get(i).target_dt)
                if (targetDate < today) {
                    //console.log("to overdue: " + modelTargets.get(i).checklist + " - " + targetDate)
                    modelTargets.setProperty(i, "overdue", true)
                } else {
                    //console.log("to upcoming: " + modelTargets.get(i).checklist + " - " + targetDate)
                    modelTargets.setProperty(i, "overdue", false)
                }
            }
        }
    }
}
