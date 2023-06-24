
Config = {}

Config.Points = {
        --[[{
            text = 'name1', -- Blipname
            group = nil,
            enabled = true, -- Blip an/ausschalten
            coords = vec3(711.9980, -992.2504, 22.9253), --Blip Koordinaten
            hidden = true, -- Blip nicht in Legende (Ja/Nein)
            colour = 3, -- Blip Farbe
            scale = 0.5, -- Blip Größe
            sprite = 76, -- Blip Type
            pedenabled = true, -- Ped an/ausschalten
            pedcoords = vec4(711.9980, -992.2504, 22.9253, 2.6461), -- Ped Koordinaten
            ped ='a_m_m_afriamer_01', -- Ped Name
            pedhash = 0xD172497E, -- Ped Hash
            pedheading = 265.0146,
            scenario = 'WORLD_HUMAN_AA_SMOKE',
            tarenabled = true, -- Ped Scenario Liste der Scenarios im Ordner
            tarcoords = vec3(948.0381, -1548.5771, 30.7740),
            tarsize = vec3(2, 2, 2),
            taroptions = {
                {
                    event = 'mor-ds:hmenu',
                    label = 'Mister Johnson'
                },
            }
            menabled = false, -- Marker ein/ausschalten
            mtype = 1, --- Marker Type
            mcoords = vec3(711.9980, -992.2504, 23.9253), -- Marker Koordinaten
            mscale = vec3(3.0, 3.0, 3.0), -- Marker Größe
            mr = 255, --Farbe
            mg = 255, --Farbe
            mb = 255, --Farbe
            ma = 128, --Farbe
            mupdown = true -- Marker hüpft
        },]]
        {
            text = 'Mister Johnson',
            enabled = false,
            coords = vec3(948.0381, -1548.5771, 30.7740),
            hidden = false,
            colour = 31,
            scale = 0.5,
            sprite = 162,
            pedenabled = true,
            pedcoords = vec3(948.0381, -1548.5771, 29.7740),
            pedheading = 265.0146,
            ped ='cs_siemonyetarian',
            pedhash = 0xC0937202,
            scenario = 'WORLD_HUMAN_AA_SMOKE',
            tarenabled = true,
            tarcoords = vec3(948.0381, -1548.5771, 30.7740),
            tarsize = vec3(2, 2, 2),
            taroptions = {
                {
                    name = 'Johnson',
                    event = 'mor-ds:hmenu',
                    label = 'Mister Johnson',
                },
            }
        },
}

Config.Price = {
    aprice = 14, -- Item afghan
    kprice = 28  -- Item kokain
}

Config.Abgabe = {
        {
            text = 'Rockfort Sam',
            enabled = false,
            coords = vec3(-626.7948, -128.1979, 39.0091),
            hidden = false,
            colour = 31,
            scale = 0.5,
            sprite = 162,
            pedenabled = true,
            pedcoords = vec3(-626.7948, -128.1979, 38.0091),
            pedheading = 279.0892,
            ped ='cs_siemonyetarian',
            pedhash = 0xC0937202,
            scenario = 'WORLD_HUMAN_AA_SMOKE',
            tarenabled = true,
            tarcoords = vec3(-626.7948, -128.1979, 39.0091),
            tarsize = vec3(2, 2, 2),
            taroptions = {
                {
                    name = 'Sam',
                    event = 'mor-ds:paketverkauf',
                    label = 'Sam',
                },
            }
        },
}