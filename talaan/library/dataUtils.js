.import "database.js" as Database
.import "functions.js" as Functions

var dataUtils = dataUtils || (function (undefined) {

    return {
        profiles: (function (currentProfile) {

            return {
                currentName: function() {
                    if (mainView.settings && mainView.mainModels && mainView.mainModels.profilesModel && mainView.mainModels.profilesModel.ready) { 
                        return mainView.mainModels.profilesModel.getItem(settings.activeProfile, "profileId").displayName
                    } else {
                        return ""
                    }
                }
                , enableOverlay: function() {
                    if (mainView.settings && mainView.mainModels && mainView.mainModels.profilesModel && mainView.mainModels.profilesModel.ready) { 
                        return mainView.mainModels.profilesModel.getItem(settings.activeProfile, "profileId").enableOverlay
                    } else {
                        return false
                    }
                }
                , overlayColor: function() {
                    if (mainView.settings && mainView.mainModels && mainView.mainModels.profilesModel && mainView.mainModels.profilesModel.ready) { 
                        return mainView.mainModels.profilesModel.getItem(settings.activeProfile, "profileId").overlayColor
                    } else {
                        return "blue"
                    }
                }
                , overlayOpacity: function() {
                    if (mainView.settings && mainView.mainModels && mainView.mainModels.profilesModel && mainView.mainModels.profilesModel.ready) { 
                        return mainView.mainModels.profilesModel.getItem(settings.activeProfile, "profileId").overlayOpacity
                    } else {
                        return 0.2
                    }
                }
                , list: function() {
                    return Database.getProfiles();
                }
                , refresh: function() {
                    mainView.mainModels.refreshProfiles();
                }
                , exists: function(displayName) {
                    return Database.checkProfileIfExist(displayName);
                }
                , add: function(displayName, enableOverlay, overlayColor, overlayOpacity) {
                    let _result = Database.newProfile(displayName, enableOverlay, overlayColor, overlayOpacity)
                    if (_result.success) {
                        this.refresh();
                    }

                    return { "success": _result.success, "exists": _result.exists }
                }
                , edit: function(profileId, displayName, newDisplayName, enableOverlay, overlayColor, overlayOpacity) {
                    let _result = Database.editProfile(profileId, displayName, newDisplayName, enableOverlay, overlayColor, overlayOpacity);
                    if (_result.success) {
                        this.refresh();
                    }

                    return { "success": _result.success, "exists": _result.exists }
                }
                , delete: function(profileId) {
                    let _result = Database.deleteProfile(profileId);
                    if (_result.success) {
                        this.refresh();
                    }

                    return { "success": _result.success }
                }
            }
        })()
        , currencies: function () {

            return {
                list: function() {
                    return Database.getCurrencies();
                }
            }
        }
        , categories: function () {

            return {
                list: function() {
                    return Database.getCategories();
                }
                , add: function(name, description, color) {
                    let _result = Database.addCategory( name, description, "", color);
                    if (_result.success) {
                        mainView.mainModels.refreshCategories("ADD")
                    }

                    return { "success": _result.success, "nameExists": _result.nameExists, "colorExists": _result.colorExists }
                }
                , edit: function(name, newName, description, color) {
                    let _result = Database.updateCategory(name, newName, description, "", color);
                    if (_result.success) {
                        mainView.mainModels.refreshCategories("EDIT")
                    }

                    return { "success": _result.success, "nameExists": _result.nameExists, "colorExists": _result.colorExists }
                }
                , delete: function(name) {
                    let _result = Database.deleteCategory(name);
                    if (_result.success) {
                        mainView.mainModels.refreshCategories("DELETE")
                    }

                    return { "success": _result.success, "hasData": _result.hasData }
                }
            }
        }
        , dashboard: function (profile) {

            return {
                breakdown: function(range) {
                    let _current = []
                    let _previous = []

                    switch (range) {
                        case "today":
                            _current = Database.getCategoryBreakdown(profile, "today");
                            _previous = Database.getCategoryBreakdown(profile, "yesterday");
                            break
                        case "thisweek":
                            _current = Database.getCategoryBreakdown(profile, "thisweek");
                            _previous = Database.getCategoryBreakdown(profile, "lastweek");
                            break
                        case "thismonth":
                            _current = Database.getCategoryBreakdown(profile, "thismonth");
                            _previous = Database.getCategoryBreakdown(profile, "lastmonth");
                            break
                        case "thisyear":
                            _current = Database.getCategoryBreakdown(profile, "thisyear");
                            _previous = Database.getCategoryBreakdown(profile, "lastyear");
                            break
                        case "recent":
                            _current = Database.getCategoryBreakdown(profile, "recent");
                            _previous = Database.getCategoryBreakdown(profile, "previousrecent");
                            break
                    }

                    return [ _current, _previous ]
                },
                trend: function(range, mode, categories, fromDate, toDate) {
                    let _current = []
                    let _previous = []

                    switch (range) {
                        case "thisweek":
                            _current = Database.getExpenseTrend(profile, "thisweek", mode, categories, fromDate, toDate);
                            _previous = Database.getExpenseTrend(profile, "lastweek", mode, categories, fromDate, toDate);
                            break
                        case "thismonth":
                            _current = Database.getExpenseTrend(profile, "thismonth", mode, categories, fromDate, toDate);
                            _previous = Database.getExpenseTrend(profile, "lastmonth", mode, categories, fromDate, toDate);
                            break
                        case "thisyear":
                            _current = Database.getExpenseTrend(profile, "thisyear", mode, categories, fromDate, toDate);
                            _previous = Database.getExpenseTrend(profile, "lastyear", mode, categories, fromDate, toDate);
                            break
                        case "recent":
                            _current = Database.getExpenseTrend(profile, "recent", mode, categories, fromDate, toDate);
                            _previous = Database.getExpenseTrend(profile, "previousrecent", mode, categories, fromDate, toDate);
                            break
                    }

                    return [ _current, _previous ]
                },
            }
        }
        , quickExpenses: function (profile) {

            return {
                list: function() {
                    return Database.getQuickExpenses(profile, "");
                }
                , add: function(expenseData) {
                    let _txtName = expenseData.name
                    let _realValue = expenseData.value
                    let _txtDescr = expenseData.description
                    let _txtCategory = expenseData.category

                    const _data = {
                        "name": _txtName
                        , "description": _txtDescr
                        , "category": _txtCategory
                        , "value": _realValue
                    }

                    let _result = Database.addQuickExpense(profile, _data)
                    if (_result.success) {
                        mainView.mainModels.refreshQuickExpense()
                    }

                    return { "success": _result.success, "exists": _result.exists}
                }
                , edit: function(expenseData) {
                    let _txtID = expenseData.expenseID
                    let _txtName = expenseData.name
                    let _realValue = expenseData.value
                    let _txtDescr = expenseData.description
                    let _txtCategory = expenseData.category

                    const _data = {
                        "id": _txtID
                        , "name": _txtName
                        , "description": _txtDescr
                        , "category": _txtCategory
                        , "value": _realValue
                    }

                    let _result = Database.editQuickExpense(profile, _data)
                    if (_result.success) {
                        mainView.mainModels.refreshQuickExpense()
                    }

                    return { "success": _result.success, "exists": _result.exists}
                }
                , delete: function(expenseID) {
                    let _result = Database.deleteQuickExpense(profile, expenseID)
                    if (_result.success) {
                        mainView.mainModels.refreshQuickExpense()
                    }

                    return { "success": _result.success, "exists": _result.exists}
                }
            }
        }
        , lists: function () {

            return {
                add: function(listData) {
                    let _txtName = listData.listName
                    let _txtDescr = listData.description
                    let _txtType = listData.type
                    let _txtCategory = listData.category
                    let _txtCreationDt = listData.creationDt
                    let _txtModifiedDt = listData.creationDt
                    let _txtCompletionDt = listData.completionDt
                    let _txtTargetDt = listData.targetDt
                    let _intStatus = listData.status
                    let _intFavorite = listData.isFavorite

                    const _data = {
                        "name": _txtName
                        , "description": _txtDescr
                        , "type": _txtType
                        , "category": _txtCategory
                        , "creationDt": _txtCreationDt
                        , "modifiedDt": _txtModifiedDt
                        , "completionDt": _txtCompletionDt
                        , "targetDt": _txtTargetDt
                        , "status": _intStatus
                        , "favorite": _intFavorite
                    }

                    let _result = Database.addNewList(_data)
                    if (_result.success) {
                        //~ mainView.mainModels.refreshValues(_data.entryDate)
                    }

                    return _result.success
                }
                , edit: function(listData) {
                    let _txtId = listData.listId
                    let _txtName = listData.listName
                    let _txtDescr = listData.description
                    let _txtType = listData.type
                    let _txtCategory = listData.category
                    let _txtCreationDt = listData.creationDt
                    let _txtModifiedDt = listData.creationDt
                    let _txtCompletionDt = listData.completionDt
                    let _txtTargetDt = listData.targetDt
                    let _intStatus = listData.status
                    let _intFavorite = listData.isFavorite

                    const _data = {
                        "listId": _txtId
                        , "name": _txtName
                        , "description": _txtDescr
                        , "type": _txtType
                        , "category": _txtCategory
                        , "creationDt": _txtCreationDt
                        , "modifiedDt": _txtModifiedDt
                        , "completionDt": _txtCompletionDt
                        , "targetDt": _txtTargetDt
                        , "status": _intStatus
                        , "favorite": _intFavorite
                    }

                    let _result = Database.updateList(_data)
                    if (_result.success) {
                        //~ mainView.mainModels.refreshValues(_data.entryDate, _txtID)
                        //~ if (_result.oldEntryDate != _data.entryDate) {
                            //~ mainView.mainModels.refreshValues(_result.oldEntryDate)
                        //~ }
                    }

                    return _result.success
                }
                , delete: function(listId) {
                    let _result = Database.deleteList(listId)
                    if (_result.success) {
                        mainView.mainModels.listsModel.removeItem(listId)
                    }

                    return _result.success
                }
                , setAsFavorite: function(listId) {
                    let _result = Database.updateListFavorite(listId, true)
                    if (_result.success) {
                        mainView.mainModels.listsModel.updateFavorite(listId, 1)
                    }

                    return _result.success
                }
                , unsetAsFavorite: function(listId) {
                    let _result = Database.updateListFavorite(listId, false)
                    if (_result.success) {
                        mainView.mainModels.listsModel.updateFavorite(listId, 0)
                    }

                    return _result.success
                }
                , archive: function(listId) {
                    let _result = Database.setListCompletionDt(listId, false)
                    if (_result.success) {
                        //~ mainView.mainModels.listsModel.removeItem(listId)
                    }

                    return _result.success
                }
                , unarchive: function(listId) {
                    let _result = Database.setListCompletionDt(listId, true)
                    if (_result.success) {
                        //~ mainView.mainModels.listsModel.removeItem(listId)
                    }

                    return _result.success
                }
                , setAsComplete: function(listId, skipUnchecked=false) {
                    let _result = Database.updateListStatus(listId, true, skipUnchecked)
                    if (_result.success) {
                        //~ mainView.mainModels.listsModel.removeItem(listId)
                    }

                    return _result.success
                }
                , setAsIncomplete: function(listId) {
                    let _result = Database.updateListStatus(listId, false, false)
                    if (_result.success) {
                        //~ mainView.mainModels.listsModel.removeItem(listId)
                    }

                    return _result.success
                }
                , saveAsTemplate: function(listId, includeComments) {
                    let _result = Database.saveListAsTemplate(listId, includeComments)

                    return _result.success
                }
                , activeList: function() {
                    return Database.getActiveLists()
                }
                , archivedList: function() {
                    return Database.getArchivedLists()
                }
                , search: function(searchText, limit, sort) {
                    return Database.searchExpenses(profile, searchText, limit, sort)
                }
            }
        }
        , listItems: function () {

            return {
                list: function(listId, sort, priorityFirst) {
                    return Database.getListItems(listId, sort, priorityFirst);
                }
                , setStatus: function(listId, name, status) {
                    return Database.updateListItemStatus(listId, name, status);
                }
            }
        }
    }
})();
