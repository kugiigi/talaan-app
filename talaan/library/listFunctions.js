function deleteList(listId) {
    if (mainView.lists.delete(listId)) {
        mainView.tooltip.display(i18n.tr("List deleted"))
    } else {
        mainView.tooltip.display(i18n.tr("Deletion failed"))
    }
}

function markAsCompleted(listId, skipUnchecked) {
    if (mainView.lists.setAsComplete(listId, skipUnchecked)) {
        mainView.tooltip.display(i18n.tr("List marked as completed"))
    } else {
        mainView.tooltip.display(i18n.tr("Failed to mark as completed"))
    }
}

function revertAsIncomplete(listId) {
    if (mainView.lists.setAsIncomplete(listId)) {
        mainView.tooltip.display(i18n.tr("List reverted as incomplete"))
    } else {
        mainView.tooltip.display(i18n.tr("Failed to revert as incomplete"))
    }
}

function archive(listId) {
    if (mainView.lists.archive(listId)) {
        mainView.tooltip.display(i18n.tr("List archived"))
    } else {
        mainView.tooltip.display(i18n.tr("Failed to archive"))
    }
}

function unarchive(listId) {
    if (mainView.lists.unarchive(listId)) {
        mainView.tooltip.display(i18n.tr("List unarchived"))
    } else {
        mainView.tooltip.display(i18n.tr("Failed to unarchive"))
    }
}

function saveAsTemplate(listId) {
    if (mainView.lists.saveAsTemplate(listId)) {
        mainView.tooltip.display(i18n.tr("List saved as template"))
    } else {
        mainView.tooltip.display(i18n.tr("Failed to save as template"))
    }
}

function setAsFavorite(listId) {
    if (mainView.lists.setAsFavorite(listId)) {
        mainView.tooltip.display(i18n.tr("List added to favorites"))
    } else {
        mainView.tooltip.display(i18n.tr("Adding to favorites failed"))
    }
}

function unsetAsFavorite(listId) {
    if (mainView.lists.unsetAsFavorite(listId)) {
        mainView.tooltip.display(i18n.tr("List removed from favorites"))
    } else {
        mainView.tooltip.display(i18n.tr("Removing from favorites failed"))
    }
}
