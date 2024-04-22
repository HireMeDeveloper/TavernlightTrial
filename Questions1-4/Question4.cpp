void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    
    if (!player) {
    
        // Memory is allocated for new player objects here, so it needs to be freed up when no longer needed
        player = new Player(nullptr);
    
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            // Free up the memory since it will no longer be used
            delete player;
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);

    if (!item) {
        // Free up the memory since it will no longer be used
        delete player;
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    // Free up the memory if code execution makes it to this point
    delete player;
}