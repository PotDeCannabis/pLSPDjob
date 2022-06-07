Config = {

    VehiculeLSPD = { 
        {buttoname = "Cruiser", rightlabel = "→", spawnname = "police3", spawnzone = vector3(442.01, -1015.53, 28.65), headingspawn = 91.11},
    },

    HelicoLSPD = { 
     	{buttonameheli = "Hélicoptère", rightlabel = "→", spawnnameheli = "supervolito", spawnzoneheli = vector3(449.1641, -981.3759, 43.6913), headingspawnheli = 91.11},
    },

    Position = {
        Boss = {vector3(448.16, -973.15, 30.68)}, 
        Coffre = {vector3(441.21, -991.45, 30.68)},
        Armurerie = {vector3(452.00, -980.17, 30.68)},
        Vestaire = {vector3(452.46, -992.66, 30.68)},
        GarageVehicule = {vector3(442.01, -1015.53, 28.65)},
        GarageHeli = {vector3(449.17761, -981.4251, 43.6913)},
        Blips = {x = 429.47, y = -981.36, z = 30.71},
    },

    amende = {
        ["amende "] = {
            {label = 'Usage abusif du klaxon', price = 1500},
            {label = 'Franchir une ligne continue', price = 1500},
            {label = 'Circulation à contresens', price = 1500},
            {label = 'Demi-tour non autorisé', price = 1500},
            {label = 'Circulation hors-route', price = 1500},
            {label = 'Non-respect des distances de sécurité', price = 1500},
            {label = 'Arrêt dangereux / interdit', price = 1500},
            {label = 'Stationnement gênant / interdit', price = 1500},
            {label = 'Non respect  de la priorité à droite', price = 1500},
            {label = 'Non-respect à un véhicule prioritaire', price = 1500},
            {label = 'Non-respect d\'un stop', price = 1500},
            {label = 'Non-respect d\'un feu rouge', price = 1500},
            {label = 'Dépassement dangereux', price = 1500},
            {label = 'Véhicule non en état', price = 1500},
            {label = 'Conduite sans permis', price = 1500},
            {label = 'Délit de fuite', price = 1500},
            {label = 'Excès de vitesse < 5 kmh', price = 1500},
            {label = 'Excès de vitesse 5-15 kmh', price = 1500},
            {label = 'Excès de vitesse 15-30 kmh', price = 1500},
            {label = 'Excès de vitesse > 30 kmh', price = 1500},
            {label = 'Entrave de la circulation', price = 1500},
            {label = 'Dégradation de la voie publique', price = 1500},
            {label = 'Trouble à l\'ordre publique', price = 1500},
            {label = 'Entrave opération de police', price = 1500},
            {label = 'Insulte envers / entre civils', price = 1500},
            {label = 'Outrage à agent de police', price = 1500},
            {label = 'Menace verbale ou intimidation envers civil', price = 1500},
            {label = 'Menace verbale ou intimidation envers policier', price = 1500},
            {label = 'Manifestation illégale', price = 1500},
            {label = 'Tentative de corruption', price = 1500},
            {label = 'Arme blanche sortie en ville', price = 1500},
            {label = 'Arme léthale sortie en ville', price = 1500},
            {label = 'Port d\'arme non autorisé (défaut de license)', price = 1500},
            {label = 'Port d\'arme illégal', price = 1500},
            {label = 'Pris en flag lockpick', price = 1500},
            {label = 'Vol de voiture', price = 1500},
            {label = 'Vente de drogue', price = 1500},
            {label = 'Fabriquation de drogue', price = 1500},
            {label = 'Possession de drogue', price = 1500},
            {label = 'Prise d\'ôtage civil', price = 1500},
            {label = 'Prise d\'ôtage agent de l\'état', price = 1500},
            {label = 'Braquage particulier', price = 1500},
            {label = 'Braquage magasin', price = 1500},
            {label = 'Braquage de banque', price = 1500},
            {label = 'Tir sur civil', price = 1500},
            {label = 'Tir sur agent de l\'état', price = 1500},
            {label = 'Tentative de meurtre sur civil', price = 1500},
            {label = 'Tentative de meurtre sur agent de l\'état', price = 1500},
            {label = 'Meurtre sur civil', price = 1500},
            {label = 'Meurte sur agent de l\'état', price = 1500}, 
            {label = 'Escroquerie à l\'entreprise', price = 1500},
        }
    },

    Tenues = {
        [0] = {
            label = "Tenue Personnel",
            minimum_grade = 0,
            variations = {male = {}, female = {}},
            onEquip = function()
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin) TriggerEvent('skinchanger:loadSkin', skin) end)
                SetPedArmour(PlayerPedId(), 0)
            end
        },
        [1] = {
            minimum_grade = 0,
            label = "Tenue LSPD",
            variations = {
            male = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 1,
                ['torso_1'] = 55,   ['torso_2'] = 0,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['arms'] = 41,
                ['pants_1'] = 52,   ['pants_2'] = 1,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 0,    ['chain_2'] = 0,
                ['ears_1'] = 2,     ['ears_2'] = 0,
            },
            female = {
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['tshirt_1'] = 15,['tshirt_2'] = 2,
                ['torso_1'] = 65, ['torso_2'] = 2,
                ['arms'] = 36, ['arms_2'] = 0,
                ['pants_1'] = 38, ['pants_2'] = 2,
                ['shoes_1'] = 12, ['shoes_2'] = 6,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['bproof_1'] = 0,
                ['chain_1'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
            }
        },
        onEquip = function()  
        end
        },
        [2] = {
            minimum_grade = 0,
            label = "Tenue SWAT",
            variations = {
            male = {
                ['tshirt_1'] = 85,  ['tshirt_2'] = 1,
                ['torso_1'] = 67,   ['torso_2'] = 0,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['arms'] = 34,
                ['pants_1'] = 58,   ['pants_2'] = 1,
                ['shoes_1'] = 25,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 0,    ['chain_2'] = 0,
                ['ears_1'] = 2,     ['ears_2'] = 0,
            },
            female = {
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['tshirt_1'] = 18,['tshirt_2'] = 2,
                ['torso_1'] = 95, ['torso_2'] = 2,
                ['arms'] = 16, ['arms_2'] = 0,
                ['pants_1'] = 28, ['pants_2'] = 2,
                ['shoes_1'] = 22, ['shoes_2'] = 6,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['bproof_1'] = 0,
                ['chain_1'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
            }
        },
        onEquip = function()  
        end
        },
        [3] = {
            minimum_grade = 8,
            label = "Tenue Commandant",
            variations = {
            male = {
                ['tshirt_1'] = 37,  ['tshirt_2'] = 1,
                ['torso_1'] = 53,   ['torso_2'] = 0,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['arms'] = 20,
                ['pants_1'] = 53,   ['pants_2'] = 1,
                ['shoes_1'] = 17,   ['shoes_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['chain_1'] = 0,    ['chain_2'] = 0,
                ['ears_1'] = 2,     ['ears_2'] = 0,
            },
            female = {
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['tshirt_1'] = 17,['tshirt_2'] = 2,
                ['torso_1'] = 63, ['torso_2'] = 2,
                ['arms'] = 32, ['arms_2'] = 0,
                ['pants_1'] = 39, ['pants_2'] = 2,
                ['shoes_1'] = 11, ['shoes_2'] = 6,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['bproof_1'] = 0,
                ['chain_1'] = 0,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
            }
        },
        onEquip = function()  
        end
        },
    }        
}
