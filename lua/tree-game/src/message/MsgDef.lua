local MsgDef = {
  send = {
        ["101001"] = {
            ["keys"] = {"accountId","accountName","channelId","serverId","md5Flag"},
            ["fmt"]  = {"S","S","i","i","S"}
        },
        ["101002"] = {
            ["keys"] = {"career","roleSex","roleName","roleKey"},
            ["fmt"]  = {"i","i","S","S"}
        },
        ["101003"] = {
            ["keys"] = {"loginSign"},
            ["fmt"]  = {"S"}
        },
        ["101901"] = {
            ["keys"] = {"cmdStr"},
            ["fmt"]  = {"S"}
        },
        ["101902"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["101903"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["101004"] = {
            ["keys"] = {"career"},
            ["fmt"]  = {"i"}
        },
        ["101005"] = {
            ["keys"] = {"stype","count"},
            ["fmt"]  = {"i","i"}
        },
        ["101006"] = {
            ["keys"] = {"stype"},
            ["fmt"]  = {"i"}
        },
        ["101007"] = {
            ["keys"] = {"sex"},
            ["fmt"]  = {"b"}
        },
        ["101008"] = {
            ["keys"] = {"roleName"},
            ["fmt"]  = {"S"}
        },
        ["101009"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["101010"] = {
            ["keys"] = {"guideId"},
            ["fmt"]  = {"i"}
        },
        ["101101"] = {
            ["keys"] = {"accountId","accountName","channelId","serverId","md5Time","md5Flag","sId"},
            ["fmt"]  = {"S","S","i","i","i","S","S"}
        },
        ["101102"] = {
            ["keys"] = {"stype"},
            ["fmt"]  = {"b"}
        },
        ["101103"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["101104"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["101201"] = {
            ["keys"] = {"tarAId","tarBId"},
            ["fmt"]  = {"L","L"}
        },
        ["101301"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["101302"] = {
            ["keys"] = {"titleId"},
            ["fmt"]  = {"i"}
        },
        ["101303"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["101304"] = {
            ["keys"] = {"headId"},
            ["fmt"]  = {"i"}
        },
        ["101202"] = {
            ["keys"] = {"fIndex","roleId","reqType"},
            ["fmt"]  = {"i","L","i"}
        },
        ["101904"] = {
            ["keys"] = {"ab"},
            ["fmt"]  = {"L"}
        },
        ["102001"] = {
            ["keys"] = {"sId"},
            ["fmt"]  = {"i"}
        },
        ["102002"] = {
            ["keys"] = {"uId"},
            ["fmt"]  = {"L"}
        },
        ["102003"] = {
            ["keys"] = {"fId"},
            ["fmt"]  = {"i"}
        },
        ["102004"] = {
            ["keys"] = {"fId"},
            ["fmt"]  = {"i"}
        },
        ["102005"] = {
            ["keys"] = {"frId"},
            ["fmt"]  = {"L"}
        },
        ["102006"] = {
            ["keys"] = {"fId"},
            ["fmt"]  = {"i"}
        },
        ["102007"] = {
            ["keys"] = {"tarId","daoId"},
            ["fmt"]  = {"L","i"}
        },
        ["102008"] = {
            ["keys"] = {"sId"},
            ["fmt"]  = {"i"}
        },
        ["102009"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["103001"] = {
            ["keys"] = {"seq"},
            ["fmt"]  = {"i"}
        },
        ["103002"] = {
            ["keys"] = {"index","amount","mId"},
            ["fmt"]  = {"i","i","i"}
        },
        ["103003"] = {
            ["keys"] = {"itemType"},
            ["fmt"]  = {"i"}
        },
        ["103004"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["104006"] = {
            ["keys"] = {"mId","amount"},
            ["fmt"]  = {"i","i"}
        },
        ["103005"] = {
            ["keys"] = {"reqType","name","index"},
            ["fmt"]  = {"i","S","i"}
        },
        ["103006"] = {
            ["keys"] = {"pageType"},
            ["fmt"]  = {"i"}
        },
        ["104001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["104002"] = {
            ["keys"] = {"index","packIndex"},
            ["fmt"]  = {"i","&i&"}
        },
        ["104003"] = {
            ["keys"] = {"toIndex","index","mId"},
            ["fmt"]  = {"i","i","i"}
        },
        ["104004"] = {
            ["keys"] = {"index","toIndex"},
            ["fmt"]  = {"i","i"}
        },
        ["104005"] = {
            ["keys"] = {"index","opType"},
            ["fmt"]  = {"i","b"}
        },
        ["104007"] = {
            ["keys"] = {"opType","toIndex","index","mid"},
            ["fmt"]  = {"i","i","i","i"}
        },
        ["104008"] = {
            ["keys"] = {"opType","xhbIndex","packIndex"},
            ["fmt"]  = {"i","i","i"}
        },
        ["105001"] = {
            ["keys"] = {"stype"},
            ["fmt"]  = {"i"}
        },
        ["105002"] = {
            ["keys"] = {"stype","index","mId","amount"},
            ["fmt"]  = {"i","i","i","i"}
        },
        ["105003"] = {
            ["keys"] = {"mType"},
            ["fmt"]  = {"i"}
        },
        ["105004"] = {
            ["keys"] = {"mType"},
            ["fmt"]  = {"i"}
        },
        ["106001"] = {
            ["keys"] = {"ctype"},
            ["fmt"]  = {"i"}
        },
        ["107001"] = {
            ["keys"] = {"cId"},
            ["fmt"]  = {"i"}
        },
        ["107002"] = {
            ["keys"] = {"stype"},
            ["fmt"]  = {"i"}
        },
        ["107003"] = {
            ["keys"] = {"fId"},
            ["fmt"]  = {"i"}
        },
        ["108001"] = {
            ["keys"] = {"index","toIndex"},
            ["fmt"]  = {"i","i"}
        },
        ["108002"] = {
            ["keys"] = {"index","flag"},
            ["fmt"]  = {"i","b"}
        },
        ["108003"] = {
            ["keys"] = {"index","toIndex"},
            ["fmt"]  = {"i","i"}
        },
        ["108004"] = {
            ["keys"] = {"indexs"},
            ["fmt"]  = {"&i&"}
        },
        ["108005"] = {
            ["keys"] = {"index","opType"},
            ["fmt"]  = {"i","b"}
        },
        ["108006"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["109001"] = {
            ["keys"] = {"stype","pageIndex","pateCount"},
            ["fmt"]  = {"i","i","i"}
        },
        ["109002"] = {
            ["keys"] = {"mailId","mState"},
            ["fmt"]  = {"L","i"}
        },
        ["109003"] = {
            ["keys"] = {"roleId","content"},
            ["fmt"]  = {"L","S"}
        },
        ["111001"] = {
            ["keys"] = {"money_zs"},
            ["fmt"]  = {"i"}
        },
        ["111002"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["111003"] = {
            ["keys"] = {"vipLvl"},
            ["fmt"]  = {"i"}
        },
        ["111004"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["111005"] = {
            ["keys"] = {"vipIcon"},
            ["fmt"]  = {"b"}
        },
        ["111201"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["112001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["112002"] = {
            ["keys"] = {"atkCount"},
            ["fmt"]  = {"i"}
        },
        ["112003"] = {
            ["keys"] = {"atkCount"},
            ["fmt"]  = {"i"}
        },
        ["113001"] = {
            ["keys"] = {"ttype"},
            ["fmt"]  = {"i"}
        },
        ["113002"] = {
            ["keys"] = {"taskId"},
            ["fmt"]  = {"i"}
        },
        ["113003"] = {
            ["keys"] = {"taskId"},
            ["fmt"]  = {"i"}
        },
        ["113004"] = {
            ["keys"] = {"mType"},
            ["fmt"]  = {"i"}
        },
        ["114001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["114002"] = {
            ["keys"] = {"tarId"},
            ["fmt"]  = {"L"}
        },
        ["114003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["114004"] = {
            ["keys"] = {"uId"},
            ["fmt"]  = {"L"}
        },
        ["114005"] = {
            ["keys"] = {"roleId","index"},
            ["fmt"]  = {"L","i"}
        },
        ["115001"] = {
            ["keys"] = {"isRest"},
            ["fmt"]  = {"b"}
        },
        ["115002"] = {
            ["keys"] = {"startType"},
            ["fmt"]  = {"b"}
        },
        ["115003"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"b"}
        },
        ["115004"] = {
            ["keys"] = {"fId"},
            ["fmt"]  = {"i"}
        },
        ["115005"] = {
            ["keys"] = {"startIndex"},
            ["fmt"]  = {"i"}
        },
        ["115006"] = {
            ["keys"] = {"count"},
            ["fmt"]  = {"i"}
        },
        ["115007"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["168002"] = {
            ["keys"] = {"rangeType","ids","rangeMin","rangeMax","titleStr","contentStr","sendTime","atts"},
            ["fmt"]  = {"i","&L&","i","i","S","S","i","&$SimpleItem&"}
        },
        ["168003"] = {
            ["keys"] = {"type","roleId","ipStr","lastTime","insertTime","reason","gmId"},
            ["fmt"]  = {"i","L","S","i","i","S","S"}
        },
        ["168004"] = {
            ["keys"] = {"type","roleId","ipStr"},
            ["fmt"]  = {"i","L","S"}
        },
        ["168006"] = {
            ["keys"] = {"playerId","first","orderNum","money","gold","completeTime"},
            ["fmt"]  = {"L","b","S","d","i","i"}
        },
        ["168901"] = {
            ["keys"] = {"cmdStr"},
            ["fmt"]  = {"S"}
        },
        ["168101"] = {
            ["keys"] = {"acts"},
            ["fmt"]  = {"#M#"}
        },
        ["168902"] = {
            ["keys"] = {"playerId","auth"},
            ["fmt"]  = {"L","b"}
        },
        ["168903"] = {
            ["keys"] = {"content"},
            ["fmt"]  = {"S"}
        },
        ["168904"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["168905"] = {
            ["keys"] = {"rsTime","endTime","opType"},
            ["fmt"]  = {"i","i","i"}
        },
        ["168201"] = {
            ["keys"] = {"playerId","indexs"},
            ["fmt"]  = {"L","&i&"}
        },
        ["168301"] = {
            ["keys"] = {"kfId"},
            ["fmt"]  = {"i"}
        },
        ["168302"] = {
            ["keys"] = {"kfId","kfName","kfIp","kfPort"},
            ["fmt"]  = {"i","S","S","i"}
        },
        ["168906"] = {
            ["keys"] = {"opType"},
            ["fmt"]  = {"i"}
        },
        ["168907"] = {
            ["keys"] = {"mailId","roleId"},
            ["fmt"]  = {"L","L"}
        },
        ["168908"] = {
            ["keys"] = {"actId","timeType","p1","p2"},
            ["fmt"]  = {"i","i","i","i"}
        },
        ["116011"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116012"] = {
            ["keys"] = {"count"},
            ["fmt"]  = {"i"}
        },
        ["116021"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116022"] = {
            ["keys"] = {"day"},
            ["fmt"]  = {"i"}
        },
        ["116031"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116032"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116041"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116042"] = {
            ["keys"] = {"level"},
            ["fmt"]  = {"i"}
        },
        ["116051"] = {
            ["keys"] = {"giftCode"},
            ["fmt"]  = {"S"}
        },
        ["116061"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116062"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116063"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116064"] = {
            ["keys"] = {"atype","index"},
            ["fmt"]  = {"b","i"}
        },
        ["116071"] = {
            ["keys"] = {"actType"},
            ["fmt"]  = {"i"}
        },
        ["116065"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116066"] = {
            ["keys"] = {"gotType"},
            ["fmt"]  = {"b"}
        },
        ["116052"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116053"] = {
            ["keys"] = {"tarRoleKey"},
            ["fmt"]  = {"S"}
        },
        ["116054"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116067"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116068"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["116069"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116070"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116072"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116073"] = {
            ["keys"] = {"playType"},
            ["fmt"]  = {"b"}
        },
        ["116081"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116082"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["116091"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116092"] = {
            ["keys"] = {"dztype"},
            ["fmt"]  = {"i"}
        },
        ["116101"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116102"] = {
            ["keys"] = {"buyId","buyCount"},
            ["fmt"]  = {"i","i"}
        },
        ["116103"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116111"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116112"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["116121"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116122"] = {
            ["keys"] = {"buyId","buyCount"},
            ["fmt"]  = {"i","i"}
        },
        ["116131"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116132"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116133"] = {
            ["keys"] = {"atype","index"},
            ["fmt"]  = {"b","i"}
        },
        ["116113"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116134"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116135"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116136"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116137"] = {
            ["keys"] = {"reqType"},
            ["fmt"]  = {"i"}
        },
        ["116138"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116139"] = {
            ["keys"] = {"playType"},
            ["fmt"]  = {"b"}
        },
        ["116140"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116141"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116142"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116143"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116144"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116145"] = {
            ["keys"] = {"gotType"},
            ["fmt"]  = {"i"}
        },
        ["116146"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116147"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116148"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116149"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116150"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["116151"] = {
            ["keys"] = {"actId"},
            ["fmt"]  = {"i"}
        },
        ["116152"] = {
            ["keys"] = {"actId"},
            ["fmt"]  = {"i"}
        },
        ["116153"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["116154"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116155"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116156"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116157"] = {
            ["keys"] = {"pageNum"},
            ["fmt"]  = {"i"}
        },
        ["116158"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116159"] = {
            ["keys"] = {"pageNum"},
            ["fmt"]  = {"i"}
        },
        ["116160"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["116161"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117001"] = {
            ["keys"] = {"icon","guildName"},
            ["fmt"]  = {"b","S"}
        },
        ["117002"] = {
            ["keys"] = {"pageIndex","guildName"},
            ["fmt"]  = {"i","S"}
        },
        ["117003"] = {
            ["keys"] = {"guildId","isOk"},
            ["fmt"]  = {"L","b"}
        },
        ["117004"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117005"] = {
            ["keys"] = {"roleId","career"},
            ["fmt"]  = {"L","b"}
        },
        ["117006"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117007"] = {
            ["keys"] = {"roleId","isOk"},
            ["fmt"]  = {"L","b"}
        },
        ["117008"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["117101"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117009"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117102"] = {
            ["keys"] = {"qf"},
            ["fmt"]  = {"b"}
        },
        ["117103"] = {
            ["keys"] = {"qfKey"},
            ["fmt"]  = {"i"}
        },
        ["117201"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117202"] = {
            ["keys"] = {"index","amount"},
            ["fmt"]  = {"i","i"}
        },
        ["117301"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117302"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117303"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117304"] = {
            ["keys"] = {"pageIndex"},
            ["fmt"]  = {"i"}
        },
        ["117305"] = {
            ["keys"] = {"cId"},
            ["fmt"]  = {"i"}
        },
        ["117010"] = {
            ["keys"] = {"gonggaoStr"},
            ["fmt"]  = {"S"}
        },
        ["117011"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117012"] = {
            ["keys"] = {"fbId"},
            ["fmt"]  = {"i"}
        },
        ["117013"] = {
            ["keys"] = {"buyCount"},
            ["fmt"]  = {"i"}
        },
        ["117306"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117014"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["117015"] = {
            ["keys"] = {"lastPower","lastLevel"},
            ["fmt"]  = {"i","i"}
        },
        ["117401"] = {
            ["keys"] = {"name"},
            ["fmt"]  = {"S"}
        },
        ["118001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["118002"] = {
            ["keys"] = {"roleName"},
            ["fmt"]  = {"S"}
        },
        ["118003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["118004"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["118005"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["118006"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["118101"] = {
            ["keys"] = {"contentStr","roleName","guildId"},
            ["fmt"]  = {"S","S","L"}
        },
        ["118102"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["118007"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["118201"] = {
            ["keys"] = {"contentStr"},
            ["fmt"]  = {"S"}
        },
        ["118301"] = {
            ["keys"] = {"index","mId","contentStr"},
            ["fmt"]  = {"i","i","S"}
        },
        ["118302"] = {
            ["keys"] = {"hbId"},
            ["fmt"]  = {"L"}
        },
        ["119001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["119002"] = {
            ["keys"] = {"pageIndex"},
            ["fmt"]  = {"i"}
        },
        ["119003"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["119004"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["119005"] = {
            ["keys"] = {"tarId","atype"},
            ["fmt"]  = {"L","b"}
        },
        ["119006"] = {
            ["keys"] = {"indexA","indexB"},
            ["fmt"]  = {"i","i"}
        },
        ["119201"] = {
            ["keys"] = {"shopId"},
            ["fmt"]  = {"b"}
        },
        ["119202"] = {
            ["keys"] = {"shop_index"},
            ["fmt"]  = {"i"}
        },
        ["119101"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["119102"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["119007"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["119103"] = {
            ["keys"] = {"zanType","day"},
            ["fmt"]  = {"b","i"}
        },
        ["119104"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["120001"] = {
            ["keys"] = {"roleId","daoId"},
            ["fmt"]  = {"L","i"}
        },
        ["120002"] = {
            ["keys"] = {"roleId","roleName","type"},
            ["fmt"]  = {"L","S","b"}
        },
        ["120003"] = {
            ["keys"] = {"daoId","mId","cardIndex"},
            ["fmt"]  = {"i","i","i"}
        },
        ["120004"] = {
            ["keys"] = {"roleId","daoId"},
            ["fmt"]  = {"L","i"}
        },
        ["120005"] = {
            ["keys"] = {"flag","daoId"},
            ["fmt"]  = {"b","i"}
        },
        ["120006"] = {
            ["keys"] = {"daoId"},
            ["fmt"]  = {"i"}
        },
        ["120007"] = {
            ["keys"] = {"daoId"},
            ["fmt"]  = {"i"}
        },
        ["120008"] = {
            ["keys"] = {"daoId"},
            ["fmt"]  = {"i"}
        },
        ["120009"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["120010"] = {
            ["keys"] = {"roleId","daoId"},
            ["fmt"]  = {"L","i"}
        },
        ["120011"] = {
            ["keys"] = {"daoId"},
            ["fmt"]  = {"i"}
        },
        ["120101"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["120102"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["120103"] = {
            ["keys"] = {"type","page"},
            ["fmt"]  = {"i","i"}
        },
        ["120104"] = {
            ["keys"] = {"matchType","isMatch"},
            ["fmt"]  = {"i","i"}
        },
        ["120105"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["120106"] = {
            ["keys"] = {"rId"},
            ["fmt"]  = {"L"}
        },
        ["120107"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["120108"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["120201"] = {
            ["keys"] = {"index","toIndex","opType"},
            ["fmt"]  = {"i","i","i"}
        },
        ["120202"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["120203"] = {
            ["keys"] = {"items"},
            ["fmt"]  = {"&i&"}
        },
        ["121001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["121002"] = {
            ["keys"] = {"fbType"},
            ["fmt"]  = {"i"}
        },
        ["122001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["122002"] = {
            ["keys"] = {"opType"},
            ["fmt"]  = {"i"}
        },
        ["122003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["122004"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["122005"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["122006"] = {
            ["keys"] = {"dhId"},
            ["fmt"]  = {"i"}
        },
        ["123001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["123002"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["123003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["123004"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["123005"] = {
            ["keys"] = {"tarAId","tarBId","tarType"},
            ["fmt"]  = {"L","L","b"}
        },
        ["123006"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["123007"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["123008"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["123009"] = {
            ["keys"] = {"tarA","tarB"},
            ["fmt"]  = {"i","i"}
        },
        ["123010"] = {
            ["keys"] = {"aorb","jbIndex"},
            ["fmt"]  = {"i","i"}
        },
        ["123011"] = {
            ["keys"] = {"bbStr"},
            ["fmt"]  = {"S"}
        },
        ["123012"] = {
            ["keys"] = {"fIndex","roleId","reqType"},
            ["fmt"]  = {"i","L","i"}
        },
        ["123013"] = {
            ["keys"] = {"frId"},
            ["fmt"]  = {"L"}
        },
        ["123014"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["124001"] = {
            ["keys"] = {"roleId","serverId","agentId"},
            ["fmt"]  = {"L","i","i"}
        },
        ["125001"] = {
            ["keys"] = {"fIndex","pageType"},
            ["fmt"]  = {"i","i"}
        },
        ["125002"] = {
            ["keys"] = {"fruitHoleId","fightSeq"},
            ["fmt"]  = {"i","i"}
        },
        ["125003"] = {
            ["keys"] = {"index","num"},
            ["fmt"]  = {"i","i"}
        },
        ["126001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["126002"] = {
            ["keys"] = {"autoBattle"},
            ["fmt"]  = {"b"}
        },
        ["126003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["126004"] = {
            ["keys"] = {"type"},
            ["fmt"]  = {"b"}
        },
        ["126005"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["127001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["127002"] = {
            ["keys"] = {"mid","packIndex"},
            ["fmt"]  = {"i","i"}
        },
        ["127003"] = {
            ["keys"] = {"mid"},
            ["fmt"]  = {"i"}
        },
        ["127004"] = {
            ["keys"] = {"mid"},
            ["fmt"]  = {"i"}
        },
        ["127005"] = {
            ["keys"] = {"starIndex"},
            ["fmt"]  = {"i"}
        }
  },
  receive = {
        ["801001"] = {
            ["keys"] = {"property"},
            ["fmt"]  = {"&$Property&"}
        },
        ["800001"] = {
            ["keys"] = {"errorId"},
            ["fmt"]  = {"i"}
        },
        ["801002"] = {
            ["keys"] = {"money"},
            ["fmt"]  = {"$Money"}
        },
        ["803001"] = {
            ["keys"] = {"packInfo"},
            ["fmt"]  = {"$PackInfo"}
        },
        ["803002"] = {
            ["keys"] = {"itemInfo"},
            ["fmt"]  = {"&$SimpleItem&"}
        },
        ["814001"] = {
            ["keys"] = {"taskInfos"},
            ["fmt"]  = {"&$TaskInfo&"}
        },
        ["818001"] = {
            ["keys"] = {"chatType","contentStr","roleId","roleName","vipLevel","vipIcon","power","guildId","guildName","ext01","titleId","toName"},
            ["fmt"]  = {"b","S","L","S","i","i","i","L","S","L","i","S"}
        },
        ["817001"] = {
            ["keys"] = {"guildId"},
            ["fmt"]  = {"L"}
        },
        ["818002"] = {
            ["keys"] = {"cType","contentStr"},
            ["fmt"]  = {"b","S"}
        },
        ["818003"] = {
            ["keys"] = {"cType","hbId","contentStr"},
            ["fmt"]  = {"b","L","S"}
        },
        ["801003"] = {
            ["keys"] = {"noticeStr"},
            ["fmt"]  = {"S"}
        },
        ["818004"] = {
            ["keys"] = {"spcInfo","jb_count","hz_count","campScore","campPlayerCount","dfCampScore","dfCampPlayerCount","topWinner"},
            ["fmt"]  = {"&S&","i","i","i","i","i","i","&$CampRankUser&"}
        },
        ["818005"] = {
            ["keys"] = {"vsUserInfo","fId","isWin"},
            ["fmt"]  = {"&$CampUserInfo&","L","i"}
        },
        ["818006"] = {
            ["keys"] = {"events"},
            ["fmt"]  = {"S"}
        },
        ["501001"] = {
            ["keys"] = {"roleInfo","packInfo","equipInfo","money","loginSign","serverTime","auth","baseFbId","superFbId","guideId","notices","roleIdStr"},
            ["fmt"]  = {"$RoleInfo","$PackInfo","&$ItemBaseInfo&","$Money","S","i","i","i","i","i","&$NoticeInfo&","S"}
        },
        ["501002"] = {
            ["keys"] = {"loginSign","roleIdStr"},
            ["fmt"]  = {"S","S"}
        },
        ["501003"] = {
            ["keys"] = {"roleInfo"},
            ["fmt"]  = {"$RoleInfo"}
        },
        ["501901"] = {
            ["keys"] = {"cmdStr","resultStr"},
            ["fmt"]  = {"S","S"}
        },
        ["501902"] = {
            ["keys"] = {"serverTime"},
            ["fmt"]  = {"i"}
        },
        ["501903"] = {
            ["keys"] = {"msgVersion","VersionStr"},
            ["fmt"]  = {"i","S"}
        },
        ["501004"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["501005"] = {
            ["keys"] = {"stype","count"},
            ["fmt"]  = {"i","i"}
        },
        ["501006"] = {
            ["keys"] = {"stype","count","buyCount"},
            ["fmt"]  = {"i","i","i"}
        },
        ["501007"] = {
            ["keys"] = {"uName"},
            ["fmt"]  = {"S"}
        },
        ["501008"] = {
            ["keys"] = {"isOk"},
            ["fmt"]  = {"b"}
        },
        ["501009"] = {
            ["keys"] = {"roleInfo"},
            ["fmt"]  = {"$RoleInfo"}
        },
        ["501010"] = {
            ["keys"] = {"guideId"},
            ["fmt"]  = {"i"}
        },
        ["501101"] = {
            ["keys"] = {"roleIdStr","career","loginSign","auth","versionId"},
            ["fmt"]  = {"S","i","S","b","i"}
        },
        ["501102"] = {
            ["keys"] = {"packInfo","equipInfo","fwPackInfo","fwUsedInfo"},
            ["fmt"]  = {"&$ItemBaseInfo&","&$ItemBaseInfo&","&$ItemBaseInfo&","&$ItemBaseInfo&"}
        },
        ["501103"] = {
            ["keys"] = {"noticeStr"},
            ["fmt"]  = {"S"}
        },
        ["501104"] = {
            ["keys"] = {"roleInfo","money","guideId","notices","fbInfos"},
            ["fmt"]  = {"$RoleInfo","$Money","i","&$NoticeInfo&","#M#"}
        },
        ["501201"] = {
            ["keys"] = {"tarACards","tarBCards","tarAName","tarBName","tarALvl","tarBLvl","tarAPower","tarBPower"},
            ["fmt"]  = {"&$ItemBaseInfo&","&$ItemBaseInfo&","S","S","i","i","i","i"}
        },
        ["501301"] = {
            ["keys"] = {"titles"},
            ["fmt"]  = {"#M#"}
        },
        ["501302"] = {
            ["keys"] = {"titleId"},
            ["fmt"]  = {"i"}
        },
        ["501303"] = {
            ["keys"] = {"headImgs"},
            ["fmt"]  = {"#M#"}
        },
        ["501304"] = {
            ["keys"] = {"headId"},
            ["fmt"]  = {"i"}
        },
        ["501202"] = {
            ["keys"] = {"cardInfo","fwInfos","equipInfos"},
            ["fmt"]  = {"$ItemBaseInfo","&$ItemBaseInfo&","&$ItemBaseInfo&"}
        },
        ["501904"] = {
            ["keys"] = {"aa","ab","ac","ad","ae"},
            ["fmt"]  = {"b","h","i","L","d"}
        },
        ["502001"] = {
            ["keys"] = {"fightReport","sId","maxCount","items","exp","moneyJb","moneyZs"},
            ["fmt"]  = {"$FightReport","i","i","&$SimpleItem&","i","i","i"}
        },
        ["502002"] = {
            ["keys"] = {"fightReport","arenaList","items","rank","money_hz","exp","jjcCount"},
            ["fmt"]  = {"$FightReport","&$ArenaInfo&","&$SimpleItem&","i","i","i","i"}
        },
        ["502003"] = {
            ["keys"] = {"fightReport","lastCount","totalStart","items","fId","thisStart","guts","totalGuts","startAward"},
            ["fmt"]  = {"$FightReport","i","i","&$SimpleItem&","i","i","i","i","i"}
        },
        ["502004"] = {
            ["keys"] = {"fightReport","fId","guildPoint","maxHp","currHp","hitStr"},
            ["fmt"]  = {"$FightReport","i","i","i","i","S"}
        },
        ["502005"] = {
            ["keys"] = {"fightReport"},
            ["fmt"]  = {"$FightReport"}
        },
        ["502006"] = {
            ["keys"] = {"fightReport"},
            ["fmt"]  = {"$FightReport"}
        },
        ["502007"] = {
            ["keys"] = {"fightReport","resType","gotCount"},
            ["fmt"]  = {"$FightReport","i","i"}
        },
        ["502008"] = {
            ["keys"] = {"fightReport","sId","playCount","exp","moneyJb","moneyZs","items"},
            ["fmt"]  = {"$FightReport","i","i","i","i","i","&$SimpleItem&"}
        },
        ["502009"] = {
            ["keys"] = {"fightReport","tarInfo","dshu","shVal","winRate","roleDw","pointShu","pwCount","lsWin"},
            ["fmt"]  = {"$FightReport","$Rank1v1UInfo","i","i","i","i","i","i","i"}
        },
        ["503001"] = {
            ["keys"] = {"packInfo"},
            ["fmt"]  = {"$PackInfo"}
        },
        ["503002"] = {
            ["keys"] = {"mId","amount"},
            ["fmt"]  = {"i","i"}
        },
        ["503003"] = {
            ["keys"] = {"items"},
            ["fmt"]  = {"&i&"}
        },
        ["503004"] = {
            ["keys"] = {"itemInfo"},
            ["fmt"]  = {"$ItemBaseInfo"}
        },
        ["504006"] = {
            ["keys"] = {"mId","amount"},
            ["fmt"]  = {"i","i"}
        },
        ["503005"] = {
            ["keys"] = {"name","reqType"},
            ["fmt"]  = {"S","i"}
        },
        ["503006"] = {
            ["keys"] = {"caliaoInfo","pageType"},
            ["fmt"]  = {"&$ItemBaseInfo&","i"}
        },
        ["504001"] = {
            ["keys"] = {"cardInfo"},
            ["fmt"]  = {"&$ItemBaseInfo&"}
        },
        ["504002"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["504003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["504004"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["504005"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["504007"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["504008"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["505001"] = {
            ["keys"] = {"vipItems","items","smItems","hyItems","lastTime","todayCount"},
            ["fmt"]  = {"&$ItemBaseInfo&","&$ItemBaseInfo&","&$ItemBaseInfo&","&$ItemBaseInfo&","i","i"}
        },
        ["505002"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["505003"] = {
            ["keys"] = {"smItems","lastTime","todayCount"},
            ["fmt"]  = {"&$ItemBaseInfo&","i","i"}
        },
        ["505004"] = {
            ["keys"] = {"hyItems","lastTime","todayCount"},
            ["fmt"]  = {"&$ItemBaseInfo&","i","i"}
        },
        ["506001"] = {
            ["keys"] = {"items","lastTime","bdCount"},
            ["fmt"]  = {"&$ItemBaseInfo&","i","i"}
        },
        ["507001"] = {
            ["keys"] = {"fbInfo","award"},
            ["fmt"]  = {"&$fbInfo&","i"}
        },
        ["507002"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["507003"] = {
            ["keys"] = {"sId","maxCount","items","exp","moneyJb"},
            ["fmt"]  = {"i","i","&$SimpleItem&","i","i"}
        },
        ["508001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["508002"] = {
            ["keys"] = {"index","lvl","ups"},
            ["fmt"]  = {"i","i","#M#"}
        },
        ["508003"] = {
            ["keys"] = {"index","jieshu"},
            ["fmt"]  = {"i","i"}
        },
        ["508004"] = {
            ["keys"] = {"index"},
            ["fmt"]  = {"i"}
        },
        ["508005"] = {
            ["keys"] = {"index","moneyJb"},
            ["fmt"]  = {"i","i"}
        },
        ["508006"] = {
            ["keys"] = {"index","awards"},
            ["fmt"]  = {"i","&$SimpleItem&"}
        },
        ["509001"] = {
            ["keys"] = {"mailInfos","maxPage","counts"},
            ["fmt"]  = {"&$MailInfo&","i","#M#"}
        },
        ["509002"] = {
            ["keys"] = {"counts"},
            ["fmt"]  = {"#M#"}
        },
        ["509003"] = {
            ["keys"] = {"suc"},
            ["fmt"]  = {"i"}
        },
        ["511001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["511002"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["511003"] = {
            ["keys"] = {"gifts"},
            ["fmt"]  = {"&i&"}
        },
        ["511004"] = {
            ["keys"] = {"gifts"},
            ["fmt"]  = {"&i&"}
        },
        ["511005"] = {
            ["keys"] = {"vipIcon"},
            ["fmt"]  = {"b"}
        },
        ["511201"] = {
            ["keys"] = {"isFirst","czList"},
            ["fmt"]  = {"b","&$CzItemInfo&"}
        },
        ["512001"] = {
            ["keys"] = {"bossId","txCount","maxTxCount","lastCount","lastTime","countTime","canBuyCount","maxBuyCount"},
            ["fmt"]  = {"i","i","i","i","i","i","i","i"}
        },
        ["512002"] = {
            ["keys"] = {"bossId","txCount","lastCount","isCrits","exp","money_jb","items"},
            ["fmt"]  = {"i","i","i","#M#","i","i","&$SimpleItem&"}
        },
        ["513001"] = {
            ["keys"] = {"taskInfos","hy","hySign"},
            ["fmt"]  = {"&$TaskInfo&","i","i"}
        },
        ["513002"] = {
            ["keys"] = {"taskInfo","gotHy"},
            ["fmt"]  = {"$TaskInfo","i"}
        },
        ["513003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["513004"] = {
            ["keys"] = {"hy","hySign"},
            ["fmt"]  = {"i","i"}
        },
        ["514001"] = {
            ["keys"] = {"arenaList","aCount","maxCount","aTime","lastTime","money_hz","is_get","canBuyCount","maxBuyCount"},
            ["fmt"]  = {"&$ArenaInfo&","i","i","i","i","i","b","i","i"}
        },
        ["514002"] = {
            ["keys"] = {"tarCards","tarName","tarLvl","tarPower","selfPower"},
            ["fmt"]  = {"&$ItemBaseInfo&","S","i","i","i"}
        },
        ["514003"] = {
            ["keys"] = {"money_hz"},
            ["fmt"]  = {"i"}
        },
        ["514004"] = {
            ["keys"] = {"roleId","items","start","money_hz","exp","jjcCount"},
            ["fmt"]  = {"L","&$SimpleItem&","i","i","i","i"}
        },
        ["514005"] = {
            ["keys"] = {"itemInfo"},
            ["fmt"]  = {"$ItemBaseInfo"}
        },
        ["515001"] = {
            ["keys"] = {"maxStart","start","atk","hp","guts","lastCount","currPass","restCount","buyCount","startAward","maxPassId"},
            ["fmt"]  = {"i","i","i","i","i","i","i","i","i","i","i"}
        },
        ["515002"] = {
            ["keys"] = {"rankInfos","startInfos"},
            ["fmt"]  = {"&$PataRankInfo&","&i&"}
        },
        ["515003"] = {
            ["keys"] = {"atk","hp","gust"},
            ["fmt"]  = {"i","i","i"}
        },
        ["515004"] = {
            ["keys"] = {"totalStart","items","fId","guts","thisStart","totalGuts"},
            ["fmt"]  = {"i","&$SimpleItem&","i","i","i","i"}
        },
        ["515005"] = {
            ["keys"] = {"items","startIndex"},
            ["fmt"]  = {"&$SimpleItem&","i"}
        },
        ["515006"] = {
            ["keys"] = {"canBuyCount","buyMoney","buyMoney10","startIndex","items"},
            ["fmt"]  = {"i","i","i","i","&$SimpleItem&"}
        },
        ["515007"] = {
            ["keys"] = {"canBuyCount","buyMoney","buyMoney10","startIndex","items"},
            ["fmt"]  = {"i","i","i","i","&$SimpleItem&"}
        },
        ["568002"] = {
            ["keys"] = {"error"},
            ["fmt"]  = {"S"}
        },
        ["568003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568004"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568006"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568901"] = {
            ["keys"] = {"resultStr"},
            ["fmt"]  = {"S"}
        },
        ["568101"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568902"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568903"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568904"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568905"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568201"] = {
            ["keys"] = {"errorStr"},
            ["fmt"]  = {"S"}
        },
        ["568301"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568302"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568906"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568907"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["568908"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["516011"] = {
            ["keys"] = {"zCount","maxCount"},
            ["fmt"]  = {"i","i"}
        },
        ["516012"] = {
            ["keys"] = {"zCount","moneyJbCrit"},
            ["fmt"]  = {"i","&$Property&"}
        },
        ["516021"] = {
            ["keys"] = {"currDay","awardState"},
            ["fmt"]  = {"i","i"}
        },
        ["516022"] = {
            ["keys"] = {"items"},
            ["fmt"]  = {"&$SimpleItem&"}
        },
        ["516031"] = {
            ["keys"] = {"isGet","timeTips","pointValue","lastTime"},
            ["fmt"]  = {"b","S","i","i"}
        },
        ["516032"] = {
            ["keys"] = {"isGet","timeTips","pointValue","lastTime"},
            ["fmt"]  = {"b","S","i","i"}
        },
        ["516041"] = {
            ["keys"] = {"awards","lastTime"},
            ["fmt"]  = {"#M#","i"}
        },
        ["516042"] = {
            ["keys"] = {"level"},
            ["fmt"]  = {"i"}
        },
        ["516051"] = {
            ["keys"] = {"itrems"},
            ["fmt"]  = {"&$SimpleItem&"}
        },
        ["516061"] = {
            ["keys"] = {"lastTime","isGet","items"},
            ["fmt"]  = {"i","b","&$SimpleItem&"}
        },
        ["516062"] = {
            ["keys"] = {"lastTime","awards","canAwards"},
            ["fmt"]  = {"i","#M#","#M#"}
        },
        ["516063"] = {
            ["keys"] = {"lastTime","sumMoney","awards"},
            ["fmt"]  = {"i","i","#M#"}
        },
        ["516064"] = {
            ["keys"] = {"atype","index","items"},
            ["fmt"]  = {"b","i","&$SimpleItem&"}
        },
        ["516071"] = {
            ["keys"] = {"acts"},
            ["fmt"]  = {"#M#"}
        },
        ["516065"] = {
            ["keys"] = {"czZs","vipExp","vipLevel","awards","gotSign"},
            ["fmt"]  = {"i","i","i","#M#","b"}
        },
        ["516066"] = {
            ["keys"] = {"gotSign","items","gotType"},
            ["fmt"]  = {"b","&$SimpleItem&","b"}
        },
        ["516052"] = {
            ["keys"] = {"roleKey","tarRoleKey","renCount","levCount","levSign"},
            ["fmt"]  = {"S","S","i","i","i"}
        },
        ["516053"] = {
            ["keys"] = {"tarRoleKey"},
            ["fmt"]  = {"S"}
        },
        ["516054"] = {
            ["keys"] = {"roleKeyFriends"},
            ["fmt"]  = {"&$RoleKeyFriend&"}
        },
        ["516067"] = {
            ["keys"] = {"leftTime","awardSigns","sumMoney"},
            ["fmt"]  = {"i","#M#","i"}
        },
        ["516068"] = {
            ["keys"] = {"index","items","awardSigns"},
            ["fmt"]  = {"i","&$SimpleItem&","#M#"}
        },
        ["516070"] = {
            ["keys"] = {"awardSign","items","gotGoods"},
            ["fmt"]  = {"i","&$SimpleItem&","&i&"}
        },
        ["516069"] = {
            ["keys"] = {"awardSign","dayCount","gotGoods","leftTime"},
            ["fmt"]  = {"i","i","&i&","i"}
        },
        ["516073"] = {
            ["keys"] = {"playType","items","gotIndex"},
            ["fmt"]  = {"b","&$SimpleItem&","i"}
        },
        ["516072"] = {
            ["keys"] = {"leftTime"},
            ["fmt"]  = {"i"}
        },
        ["516081"] = {
            ["keys"] = {"lastTime","todayTime","sumMoneyZs","todayZan","qmthList"},
            ["fmt"]  = {"i","i","i","i","&$QmthItemInfo&"}
        },
        ["516082"] = {
            ["keys"] = {"qmthList","todayZan","awardZs"},
            ["fmt"]  = {"&$QmthItemInfo&","i","i"}
        },
        ["516091"] = {
            ["keys"] = {"lastTime","zdCount","sumMoneyZs","awards"},
            ["fmt"]  = {"i","i","i","#M#"}
        },
        ["516092"] = {
            ["keys"] = {"zdCount","awards","bjs"},
            ["fmt"]  = {"i","&$SimpleItem&","#M#"}
        },
        ["516101"] = {
            ["keys"] = {"lastTime","todayTime","canBuys"},
            ["fmt"]  = {"i","i","#M#"}
        },
        ["516102"] = {
            ["keys"] = {"buyCount","items"},
            ["fmt"]  = {"i","&$SimpleItem&"}
        },
        ["516103"] = {
            ["keys"] = {"actGuildzbList","lastTime","openDay"},
            ["fmt"]  = {"&$ActGuildzbInfo&","i","i"}
        },
        ["516111"] = {
            ["keys"] = {"lastTime","todayTime","sumMoneyZs","todayZan","qmthList"},
            ["fmt"]  = {"i","i","i","i","&$QmthItemInfo&"}
        },
        ["516112"] = {
            ["keys"] = {"awardZs","todayZan","qmthList"},
            ["fmt"]  = {"i","i","&$QmthItemInfo&"}
        },
        ["516121"] = {
            ["keys"] = {"lastTime","todayTime","canBuys"},
            ["fmt"]  = {"i","i","#M#"}
        },
        ["516122"] = {
            ["keys"] = {"buyCount","items"},
            ["fmt"]  = {"i","&$SimpleItem&"}
        },
        ["516131"] = {
            ["keys"] = {"lastTime","actTime","awards","canAwards"},
            ["fmt"]  = {"i","i","#M#","#M#"}
        },
        ["516132"] = {
            ["keys"] = {"lastTime","actTime","sumMoney","awards"},
            ["fmt"]  = {"i","i","i","#M#"}
        },
        ["516133"] = {
            ["keys"] = {"atype","index","items"},
            ["fmt"]  = {"b","i","&$SimpleItem&"}
        },
        ["516113"] = {
            ["keys"] = {"preList"},
            ["fmt"]  = {"&$QmthItemInfo&"}
        },
        ["516134"] = {
            ["keys"] = {"awardSign","dayCount","gotGoods","leftTime","dayLeft"},
            ["fmt"]  = {"i","i","&i&","i","i"}
        },
        ["516135"] = {
            ["keys"] = {"awardSign","items","gotGoods"},
            ["fmt"]  = {"i","&$SimpleItem&","&i&"}
        },
        ["516136"] = {
            ["keys"] = {"mcBuySign","zsBuySign","mcLastGotTime","zsLastGotTime","curTime","mcBuyTime","leftTime","mcCurDay"},
            ["fmt"]  = {"i","i","i","i","i","i","i","i"}
        },
        ["516137"] = {
            ["keys"] = {"mcLastGotTime","zsLastGotTime","reqType","curTime","gotZs"},
            ["fmt"]  = {"i","i","i","i","i"}
        },
        ["516138"] = {
            ["keys"] = {"leftTime"},
            ["fmt"]  = {"i"}
        },
        ["516139"] = {
            ["keys"] = {"playType","items","gotIndex"},
            ["fmt"]  = {"b","&$SimpleItem&","i"}
        },
        ["516140"] = {
            ["keys"] = {"vipDay","todayLeftTime","buySign"},
            ["fmt"]  = {"i","i","i"}
        },
        ["516141"] = {
            ["keys"] = {"buySign","items"},
            ["fmt"]  = {"i","&$SimpleItem&"}
        },
        ["516142"] = {
            ["keys"] = {"leftTime","days","sign"},
            ["fmt"]  = {"i","i","i"}
        },
        ["516143"] = {
            ["keys"] = {"sign","items"},
            ["fmt"]  = {"i","&$SimpleItem&"}
        },
        ["516144"] = {
            ["keys"] = {"leftTime","awardSigns","dayCostZs"},
            ["fmt"]  = {"i","#M#","i"}
        },
        ["516145"] = {
            ["keys"] = {"awardSigns","gotType","items"},
            ["fmt"]  = {"#M#","i","&$SimpleItem&"}
        },
        ["516146"] = {
            ["keys"] = {"day","count","remainTime","type"},
            ["fmt"]  = {"b","b","i","b"}
        },
        ["516148"] = {
            ["keys"] = {"remainTime"},
            ["fmt"]  = {"i"}
        },
        ["516149"] = {
            ["keys"] = {"lastTime","sumMoney","awards"},
            ["fmt"]  = {"i","i","#M#"}
        },
        ["516150"] = {
            ["keys"] = {"index","items"},
            ["fmt"]  = {"i","&$SimpleItem&"}
        },
        ["516151"] = {
            ["keys"] = {"activeSign","awardSign","todayLeftTime"},
            ["fmt"]  = {"i","i","i"}
        },
        ["516152"] = {
            ["keys"] = {"awardSign","actId","items","leftTime"},
            ["fmt"]  = {"i","i","&$SimpleItem&","i"}
        },
        ["516153"] = {
            ["keys"] = {"index","items","freeLotteryTimes","costLottryTimes","gotStatus","luckyBags"},
            ["fmt"]  = {"i","&$SimpleItem&","i","i","#M#","&$LuckyBag&"}
        },
        ["516154"] = {
            ["keys"] = {"costRfeTimes","gotStatus","luckyBags","costLottryTimes"},
            ["fmt"]  = {"i","#M#","&$LuckyBag&","i"}
        },
        ["516155"] = {
            ["keys"] = {"gotStatus","freeLotteryTimes","costRfeTimes","luckyBags","costLottryTimes","actLeftTime","zeroLeftTime"},
            ["fmt"]  = {"#M#","i","i","&$LuckyBag&","i","i","i"}
        },
        ["516156"] = {
            ["keys"] = {"zsPool","peiod","lastSpecialTickey","lastSpecialName","awardDownTime","specGotZs","actLeftTime","tickyNum"},
            ["fmt"]  = {"i","i","i","S","i","i","i","i"}
        },
        ["516157"] = {
            ["keys"] = {"pageNum","tickeyList","tickeyNum"},
            ["fmt"]  = {"i","&i&","i"}
        },
        ["516158"] = {
            ["keys"] = {"peiod","awardUsers"},
            ["fmt"]  = {"i","&$TickeyUser&"}
        },
        ["516159"] = {
            ["keys"] = {"pageNum","tickeyList","tickeyNum"},
            ["fmt"]  = {"i","&i&","i"}
        },
        ["516160"] = {
            ["keys"] = {"diamond","remainTime","count"},
            ["fmt"]  = {"i","i","i"}
        },
        ["516161"] = {
            ["keys"] = {"remainTime","count","diamond"},
            ["fmt"]  = {"i","i","i"}
        },
        ["517001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["517002"] = {
            ["keys"] = {"maxPage","guildList"},
            ["fmt"]  = {"i","&$GuildInfo&"}
        },
        ["517003"] = {
            ["keys"] = {"guildId","isOk"},
            ["fmt"]  = {"L","b"}
        },
        ["517004"] = {
            ["keys"] = {"userList","sqCount"},
            ["fmt"]  = {"&$GuildUserInfo&","i"}
        },
        ["517006"] = {
            ["keys"] = {"userList"},
            ["fmt"]  = {"&$GuildUserSimpleInfo&"}
        },
        ["517007"] = {
            ["keys"] = {"roleId","guildPower","guildCount"},
            ["fmt"]  = {"L","i","i"}
        },
        ["517005"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["517008"] = {
            ["keys"] = {"guildPower","guildCount"},
            ["fmt"]  = {"i","i"}
        },
        ["517101"] = {
            ["keys"] = {"guildLevel","guildName","guildExp","guildPoint","qfJindu","qfRenshu","qfAwardId","isQf","qfAwards","qfInfos"},
            ["fmt"]  = {"i","S","i","i","i","i","i","b","#M#","&S&"}
        },
        ["517009"] = {
            ["keys"] = {"guildId","guildName","guildLevel","guildExp","guildPoint","guildCount","guildPower","guildGonggao","guildFbId","job","areaRank","worldRank","changeNameSign"},
            ["fmt"]  = {"L","S","i","i","i","i","i","S","i","b","i","i","i"}
        },
        ["517102"] = {
            ["keys"] = {"guildLevel","guildExp","guildPoint","qfJindu","qfRenshu","qfAwardId","isQf","qfAwards","isCrit"},
            ["fmt"]  = {"i","i","i","i","i","i","b","#M#","b"}
        },
        ["517103"] = {
            ["keys"] = {"items"},
            ["fmt"]  = {"&$SimpleItem&"}
        },
        ["517201"] = {
            ["keys"] = {"itemInfos","money_gx"},
            ["fmt"]  = {"&$ItemBaseInfo&","i"}
        },
        ["517202"] = {
            ["keys"] = {"index","buyCount","guildPoint"},
            ["fmt"]  = {"i","i","i"}
        },
        ["517301"] = {
            ["keys"] = {"gkAwards","fbCount","canBuyCount","maxBuyCount","fbId","maxHp","currHp"},
            ["fmt"]  = {"#M#","i","i","i","i","i","i"}
        },
        ["517302"] = {
            ["keys"] = {"fbAwards"},
            ["fmt"]  = {"#M#"}
        },
        ["517303"] = {
            ["keys"] = {"hitRankList"},
            ["fmt"]  = {"&$GuildMemberDP&"}
        },
        ["517304"] = {
            ["keys"] = {"pageMax","selfRank","rankInfos"},
            ["fmt"]  = {"i","i","&$GuildRankInfo&"}
        },
        ["517305"] = {
            ["keys"] = {"items","cId"},
            ["fmt"]  = {"&$SimpleItem&","i"}
        },
        ["517010"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["517011"] = {
            ["keys"] = {"dtList"},
            ["fmt"]  = {"&S&"}
        },
        ["517012"] = {
            ["keys"] = {"items","fbId"},
            ["fmt"]  = {"&$SimpleItem&","i"}
        },
        ["517013"] = {
            ["keys"] = {"fbCount","canBuyCount"},
            ["fmt"]  = {"i","i"}
        },
        ["517306"] = {
            ["keys"] = {"selfRank","rankInfos"},
            ["fmt"]  = {"i","&$GuildRankInfo&"}
        },
        ["517014"] = {
            ["keys"] = {"lastPower","lastLevel"},
            ["fmt"]  = {"i","i"}
        },
        ["517015"] = {
            ["keys"] = {"lastPower","lastLevel"},
            ["fmt"]  = {"i","i"}
        },
        ["517401"] = {
            ["keys"] = {"changeNameSign","name"},
            ["fmt"]  = {"i","S"}
        },
        ["518001"] = {
            ["keys"] = {"friendList","tlCount"},
            ["fmt"]  = {"&$FriendInfo&","i"}
        },
        ["518002"] = {
            ["keys"] = {"friendList"},
            ["fmt"]  = {"&$FriendInfo&"}
        },
        ["518003"] = {
            ["keys"] = {"friendList","canLingTl"},
            ["fmt"]  = {"&$FriendInfo&","i"}
        },
        ["518004"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["518005"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["518006"] = {
            ["keys"] = {"roleId","canLingTl"},
            ["fmt"]  = {"L","i"}
        },
        ["518101"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["518102"] = {
            ["keys"] = {"roleId","roleName","roleLevel","vipLevel","vipIcon","power","isOnline","isFriend","guildName"},
            ["fmt"]  = {"L","S","i","i","i","i","b","b","S"}
        },
        ["518007"] = {
            ["keys"] = {"roleId"},
            ["fmt"]  = {"L"}
        },
        ["518201"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["518301"] = {
            ["keys"] = {"hbId","mId","contentStr"},
            ["fmt"]  = {"L","i","i"}
        },
        ["518302"] = {
            ["keys"] = {"hbId","mId","moneyZs","flag","awards"},
            ["fmt"]  = {"L","i","i","b","&$HongbaoItemInfo&"}
        },
        ["519001"] = {
            ["keys"] = {"dsState","isReady","lastTime","users","rankStrs"},
            ["fmt"]  = {"b","b","i","&$SmdsUserInfo&","&S&"}
        },
        ["519002"] = {
            ["keys"] = {"selfRank","smdsArrays","maxPage","groupId"},
            ["fmt"]  = {"i","&$SmdsArrayInfo&","i","i"}
        },
        ["519003"] = {
            ["keys"] = {"videoArrays","selfVideo"},
            ["fmt"]  = {"&$SmdsVideoInfo&","&$SmdsVideoInfo&"}
        },
        ["519004"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["519005"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["519006"] = {
            ["keys"] = {"winIndex","atype","awards"},
            ["fmt"]  = {"i","i","#M#"}
        },
        ["519201"] = {
            ["keys"] = {"shopList","refreshTime","smdsRank"},
            ["fmt"]  = {"#M#","i","i"}
        },
        ["519202"] = {
            ["keys"] = {"shop_index"},
            ["fmt"]  = {"i"}
        },
        ["519101"] = {
            ["keys"] = {"flag","isZan","roleId","roleName","roleIcon","zanCount","zanType","zanJb"},
            ["fmt"]  = {"b","b","L","S","i","i","i","i"}
        },
        ["519102"] = {
            ["keys"] = {"awards","currDay"},
            ["fmt"]  = {"#M#","i"}
        },
        ["519007"] = {
            ["keys"] = {"ranks"},
            ["fmt"]  = {"&$SmdsUserInfo&"}
        },
        ["519103"] = {
            ["keys"] = {"zanType","today"},
            ["fmt"]  = {"b","i"}
        },
        ["519104"] = {
            ["keys"] = {"zanCount","zanType","isZan"},
            ["fmt"]  = {"i","i","b"}
        },
        ["520001"] = {
            ["keys"] = {"daoId","mId","cardId","styleId","cardAdd","helpAdd","totalLastTime","nextAwardTime","awardJb","awardState","state","genEvents","cheerName","qdState","score","roleIcon","bqdCount","loseCount"},
            ["fmt"]  = {"i","i","i","i","i","i","i","i","i","b","b","&S&","S","i","i","i","i","i"}
        },
        ["520002"] = {
            ["keys"] = {"roleId","roleName","helpCount","wkList","qdCount","score","cheerCount"},
            ["fmt"]  = {"L","S","i","&$WakuangInfo&","i","i","i"}
        },
        ["520003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["520004"] = {
            ["keys"] = {"state"},
            ["fmt"]  = {"b"}
        },
        ["520005"] = {
            ["keys"] = {"wkFriendList"},
            ["fmt"]  = {"&$WakuangFriend&"}
        },
        ["520006"] = {
            ["keys"] = {"daoId","mId","award","state"},
            ["fmt"]  = {"i","i","i","i"}
        },
        ["520007"] = {
            ["keys"] = {"daoId","mId","award","state"},
            ["fmt"]  = {"i","i","i","b"}
        },
        ["520008"] = {
            ["keys"] = {"daoId","speedCount","speedMoney","awardMoney"},
            ["fmt"]  = {"i","i","i","i"}
        },
        ["520009"] = {
            ["keys"] = {"enemyList"},
            ["fmt"]  = {"&$WakuangFriend&"}
        },
        ["520010"] = {
            ["keys"] = {"roleId","daoId"},
            ["fmt"]  = {"L","i"}
        },
        ["520011"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["520101"] = {
            ["keys"] = {"leftTime","topWinner","campScore","campPlayerCount","selfUserInfo","jb_count","hz_count","dfCampScore","dfCampPlayerCount","timeStatu","dieTime"},
            ["fmt"]  = {"i","&$CampUserInfo&","i","i","$CampUserInfo","i","i","i","i","i","i"}
        },
        ["520102"] = {
            ["keys"] = {"camp","campScore","campPlayerCount","dfCampScore","dfCampPlayerCount"},
            ["fmt"]  = {"b","i","i","i","i"}
        },
        ["520103"] = {
            ["keys"] = {"jusList","eviList","jusMaxPage","eviMaxPage"},
            ["fmt"]  = {"&$CampListUser&","&$CampListUser&","i","i"}
        },
        ["520104"] = {
            ["keys"] = {"dieTime"},
            ["fmt"]  = {"i"}
        },
        ["520105"] = {
            ["keys"] = {"atk","hp","inspire"},
            ["fmt"]  = {"i","i","i"}
        },
        ["520106"] = {
            ["keys"] = {"fightReport"},
            ["fmt"]  = {"$FightReport"}
        },
        ["520107"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["520108"] = {
            ["keys"] = {"events"},
            ["fmt"]  = {"&S&"}
        },
        ["520201"] = {
            ["keys"] = {"changeInfos"},
            ["fmt"]  = {"&$PackInfo&"}
        },
        ["520202"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["520203"] = {
            ["keys"] = {"index","lev","extExp"},
            ["fmt"]  = {"i","i","i"}
        },
        ["521001"] = {
            ["keys"] = {"time","openFuben"},
            ["fmt"]  = {"i","&$DailyFuBenInfo&"}
        },
        ["521002"] = {
            ["keys"] = {"vipBuyCount"},
            ["fmt"]  = {"i"}
        },
        ["522001"] = {
            ["keys"] = {"lzId","resNum","spNum","items"},
            ["fmt"]  = {"i","i","i","&$ItemBaseInfo&"}
        },
        ["522002"] = {
            ["keys"] = {"lzId","resNum","gots"},
            ["fmt"]  = {"i","i","&$ItemBaseInfo&"}
        },
        ["522003"] = {
            ["keys"] = {"lzId","gots"},
            ["fmt"]  = {"i","&$ItemBaseInfo&"}
        },
        ["522004"] = {
            ["keys"] = {"resNum","changeList"},
            ["fmt"]  = {"i","&$ItemBaseInfo&"}
        },
        ["522005"] = {
            ["keys"] = {"changeList","spNum"},
            ["fmt"]  = {"&$ItemBaseInfo&","i"}
        },
        ["522006"] = {
            ["keys"] = {"spNum","gots"},
            ["fmt"]  = {"i","&$ItemBaseInfo&"}
        },
        ["523001"] = {
            ["keys"] = {"selfRoleName","winRate","pointShu","roleDw","figthCount","shenhuen","nextFightCountTime","canBuyCount","currSj","djs"},
            ["fmt"]  = {"S","i","i","i","i","i","i","i","i","#M#"}
        },
        ["523002"] = {
            ["keys"] = {"logList","roleDw","preDw"},
            ["fmt"]  = {"&$Rank1v1LogInfo&","i","i"}
        },
        ["523003"] = {
            ["keys"] = {"rankList","selfRank"},
            ["fmt"]  = {"&$Rank1v1RankInfo&","i"}
        },
        ["523004"] = {
            ["keys"] = {"pwCount","canBuyCount","nextTime"},
            ["fmt"]  = {"i","i","i"}
        },
        ["523005"] = {
            ["keys"] = {"tarACards","tarBCards","tarAName","tarBName","tarALvl","tarBLvl","tarAPower","tarBPower"},
            ["fmt"]  = {"&$ItemBaseInfo&","&$ItemBaseInfo&","S","S","i","i","i","i"}
        },
        ["523006"] = {
            ["keys"] = {"rankUkings","nextTime","day","state"},
            ["fmt"]  = {"&$Rank1v1UKingInfo&","i","i","i"}
        },
        ["523007"] = {
            ["keys"] = {"mbrs","mbzs","zqwzName","sex","todayMb"},
            ["fmt"]  = {"i","i","S","i","b"}
        },
        ["523008"] = {
            ["keys"] = {"mbrs","mbzs"},
            ["fmt"]  = {"i","i"}
        },
        ["523009"] = {
            ["keys"] = {"tarAsj","tarAstr","tarBsj","tarBstr","moneyJb","selfAb","jcAb"},
            ["fmt"]  = {"i","S","i","S","i","b","i"}
        },
        ["523010"] = {
            ["keys"] = {"aorb","moneyJb"},
            ["fmt"]  = {"i","i"}
        },
        ["523011"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["523012"] = {
            ["keys"] = {"cardInfo","fwInfos","equipInfos"},
            ["fmt"]  = {"$ItemBaseInfo","&$ItemBaseInfo&","&$ItemBaseInfo&"}
        },
        ["523013"] = {
            ["keys"] = {"fightReport","atkRoleName","defRoleName"},
            ["fmt"]  = {"$FightReport","S","S"}
        },
        ["523014"] = {
            ["keys"] = {"frList"},
            ["fmt"]  = {"&$WzzzVideoListItem&"}
        },
        ["524001"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["525001"] = {
            ["keys"] = {"atk","schedule","fruitMap","pageType","redMap"},
            ["fmt"]  = {"i","i","#M#","i","#M#"}
        },
        ["525002"] = {
            ["keys"] = {"fruitMap","atk","schedule","pageRed"},
            ["fmt"]  = {"#M#","i","i","i"}
        },
        ["525003"] = {
            ["keys"] = {},
            ["fmt"]  = {}
        },
        ["526001"] = {
            ["keys"] = {"fightReport","gold","curHpPercent","rebornTime","hurt","autoBattle","itemList"},
            ["fmt"]  = {"$FightReport","i","i","i","i","b","&$ItemBaseInfo&"}
        },
        ["526002"] = {
            ["keys"] = {"autoBattle"},
            ["fmt"]  = {"b"}
        },
        ["526003"] = {
            ["keys"] = {"rankingList","lastHitRankInfo","myRankInfo"},
            ["fmt"]  = {"&$WorldBossRankInfo&","$WorldBossRankInfo","$WorldBossRankInfo"}
        },
        ["526004"] = {
            ["keys"] = {"inspirePercent","inspireAwards"},
            ["fmt"]  = {"i","&$ItemBaseInfo&"}
        },
        ["526005"] = {
            ["keys"] = {"curHpPercent","remainTime","inspirePercent","rebornTime","isAutoBattle","bossGroupIndex","recentFightList","startToEndTime"},
            ["fmt"]  = {"i","i","i","i","b","i","&$WorldBossRankInfo&","i"}
        },
        ["527001"] = {
            ["keys"] = {"allStep","starExp","starSign"},
            ["fmt"]  = {"#M#","#M#","#M#"}
        },
        ["527002"] = {
            ["keys"] = {"step","mid"},
            ["fmt"]  = {"i","i"}
        },
        ["527003"] = {
            ["keys"] = {"items","step","starIndex","starExp","mid"},
            ["fmt"]  = {"&$SimpleItem&","i","i","i","i"}
        },
        ["527004"] = {
            ["keys"] = {"items","step","mid"},
            ["fmt"]  = {"&$SimpleItem&","i","i"}
        },
        ["527005"] = {
            ["keys"] = {"items","awardSign","starIndex"},
            ["fmt"]  = {"&$SimpleItem&","i","i"}
        }
  },
  struct = {
        ["WzzzVideoListItem"] = {
            ["keys"] = {"frId","win"},
            ["fmt"]  = {"L","i"}
        },
        ["RoleInfo"] = {
            ["keys"] = {"roleId","roleName","sex","career","roleLevel","roleExp","power","vip","guildId","titleId","guildName","vipIcon","roleProperty"},
            ["fmt"]  = {"L","S","i","i","i","i","i","i","L","i","S","i","&$Property&"}
        },
        ["Property"] = {
            ["keys"] = {"type","value"},
            ["fmt"]  = {"i","i"}
        },
        ["CardInfo"] = {
            ["keys"] = {"index","seq","mId","propertys"},
            ["fmt"]  = {"i","i","i","&$Property&"}
        },
        ["ItemBaseInfo"] = {
            ["keys"] = {"index","seq","mId","amount","propertys"},
            ["fmt"]  = {"i","i","i","i","&$Property&"}
        },
        ["ItemEquipInfo"] = {
            ["keys"] = {"index","propertys"},
            ["fmt"]  = {"i","&$Property&"}
        },
        ["Money"] = {
            ["keys"] = {"moneyZs","moneyJb","moneyHz","moneySh","moneyHy","moneyGx"},
            ["fmt"]  = {"i","i","i","i","i","i"}
        },
        ["PackInfo"] = {
            ["keys"] = {"seq","opType","itemBaseInfo"},
            ["fmt"]  = {"i","b","&$ItemBaseInfo&"}
        },
        ["FightBout"] = {
            ["keys"] = {"bout","atk","skillId","buffs","buffHurt","targets"},
            ["fmt"]  = {"b","b","i","#M#","#M#","&$FightTarget&"}
        },
        ["FightTarget"] = {
            ["keys"] = {"tar","hurts","buffs"},
            ["fmt"]  = {"i","#M#","#M#"}
        },
        ["fbInfo"] = {
            ["keys"] = {"fId","start","fbCount"},
            ["fmt"]  = {"i","i","i"}
        },
        ["FightReport"] = {
            ["keys"] = {"selfArmy","targetArmy","bouts","win","start"},
            ["fmt"]  = {"&$ArmyInfo&","&$ArmyInfo&","&$FightBout&","i","i"}
        },
        ["ArmyInfo"] = {
            ["keys"] = {"index","mid","currHp","maxHp","maxMp"},
            ["fmt"]  = {"i","i","i","i","i"}
        },
        ["SimpleItem"] = {
            ["keys"] = {"index","mId","amount"},
            ["fmt"]  = {"i","i","i"}
        },
        ["MailInfo"] = {
            ["keys"] = {"mailId","mtype","titleStr","contentStr","mState","lastTime","sendRoleId","items"},
            ["fmt"]  = {"L","i","S","S","i","i","L","&$SimpleItem&"}
        },
        ["ArenaInfo"] = {
            ["keys"] = {"index","uId","uName","uRank","uPower","uSex"},
            ["fmt"]  = {"i","L","S","i","i","i"}
        },
        ["TaskInfo"] = {
            ["keys"] = {"taskId","pass","is_get","tmpInt"},
            ["fmt"]  = {"i","i","b","i"}
        },
        ["PataRankInfo"] = {
            ["keys"] = {"index","start","uName","totalStart","isSelf","moneyZs"},
            ["fmt"]  = {"i","i","S","i","b","i"}
        },
        ["NoticeInfo"] = {
            ["keys"] = {"index","title","timeStr","contentStr"},
            ["fmt"]  = {"b","S","S","S"}
        },
        ["GuildInfo"] = {
            ["keys"] = {"guildId","guildName","guildIcon","guildLevel","guildPower","adminName","count","maxCount","fbId","isShenqing","minPower"},
            ["fmt"]  = {"L","S","b","i","i","S","i","i","i","b","i"}
        },
        ["GuildUserInfo"] = {
            ["keys"] = {"roleId","roleName","job","power","roleLevel","roleIcon","vipLevel","lastTime","todayPoint","totalPoint"},
            ["fmt"]  = {"L","S","b","i","i","i","i","i","i","i"}
        },
        ["GuildUserSimpleInfo"] = {
            ["keys"] = {"roleId","roleName","power","roleLevel","vipLevel","lastTime","roleIcon"},
            ["fmt"]  = {"L","S","i","i","i","i","i"}
        },
        ["FriendInfo"] = {
            ["keys"] = {"roleId","roleName","roleLevel","power","vipLevel","roleIcon","listTime","isTl","guildName"},
            ["fmt"]  = {"L","S","i","i","i","i","i","b","S"}
        },
        ["GuildMemberDP"] = {
            ["keys"] = {"roleId","roleName","roleIcon","rank","todayCount","hitStr","vipLevel"},
            ["fmt"]  = {"L","S","i","i","i","S","i"}
        },
        ["GuildRankInfo"] = {
            ["keys"] = {"guildId","rank","guildName","guildLevel","guildFbId","guildIcon","guildCount","adminName","awardZs"},
            ["fmt"]  = {"L","i","S","i","i","b","i","S","i"}
        },
        ["SmdsUserInfo"] = {
            ["keys"] = {"index","roleId","roleName","sex","rank","guildName"},
            ["fmt"]  = {"i","L","S","i","i","S"}
        },
        ["SmdsArrayInfo"] = {
            ["keys"] = {"roleId","roleName","power"},
            ["fmt"]  = {"L","S","i"}
        },
        ["SmdsVideoInfo"] = {
            ["keys"] = {"vtype","frIndex","roleAName","roleBName","win","videoId"},
            ["fmt"]  = {"b","i","S","S","b","L"}
        },
        ["CzItemInfo"] = {
            ["keys"] = {"index","moneyRmb","moneyZs","isFirst"},
            ["fmt"]  = {"i","i","i","b"}
        },
        ["HongbaoItemInfo"] = {
            ["keys"] = {"roleId","roleName","roleIcon","moneyZs","flag"},
            ["fmt"]  = {"L","S","i","i","b"}
        },
        ["WakuangInfo"] = {
            ["keys"] = {"daoId","cardId","mId","lastTime","state","awardState","helpName","bqdCount","cheerName","loseCount","cheerScore","bqc","atkAward"},
            ["fmt"]  = {"i","i","i","i","b","b","S","i","S","i","i","i","i"}
        },
        ["WakuangFriend"] = {
            ["keys"] = {"roleId","roleName","roleIcon","level","vipLevel","daoCount","helpCount","guildName","score","txDaoCount","qdResCount","qdDaoType","hasInvite","lastTime"},
            ["fmt"]  = {"L","S","i","i","i","i","i","S","i","i","i","i","i","i"}
        },
        ["RoleKeyFriend"] = {
            ["keys"] = {"roleName","firstGlod","awardZs"},
            ["fmt"]  = {"S","i","i"}
        },
        ["CampUserInfo"] = {
            ["keys"] = {"roleName","power","camp","rankConCout","rId","maxConWinCount","curConWinCount","winCount","loseCount","autoMatchStatu","matchStatu","vipLevel","isJion","roleIcon","hpRate","campScore","campPlayerCount","inspireCount","events","roleId"},
            ["fmt"]  = {"S","i","i","i","L","i","i","i","i","i","i","i","i","i","i","i","i","i","S","L"}
        },
        ["QmthItemInfo"] = {
            ["keys"] = {"index","roleName","roleSex","dianZan","czZs"},
            ["fmt"]  = {"i","S","i","i","i"}
        },
        ["ActGuildzbInfo"] = {
            ["keys"] = {"rank","gName","gLevel","roleName","fbJindu","gPower"},
            ["fmt"]  = {"i","S","i","S","i","i"}
        },
        ["CampListUser"] = {
            ["keys"] = {"power","camp","roleId","roleIcon","vipLevel","roleName"},
            ["fmt"]  = {"i","i","L","i","i","S"}
        },
        ["CampRankUser"] = {
            ["keys"] = {"roleName","rankConCout"},
            ["fmt"]  = {"S","i"}
        },
        ["ItemFuWenInfo"] = {
            ["keys"] = {"seq","mId","amount","upLev","leftExp","propertys","index"},
            ["fmt"]  = {"i","i","i","i","i","&$Property&","i"}
        },
        ["DailyFuBenInfo"] = {
            ["keys"] = {"difficulty","playCount","vipBuyCount","fbType"},
            ["fmt"]  = {"i","i","i","i"}
        },
        ["Rank1v1UKingInfo"] = {
            ["keys"] = {"index","namePre","roleName","roleIcon","win","frId"},
            ["fmt"]  = {"b","S","S","i","b","L"}
        },
        ["KfRoleInfo"] = {
            ["keys"] = {"roleId","agentId","roleName","sex","level","power","vipLevel"},
            ["fmt"]  = {"L","i","S","i","i","i","i"}
        },
        ["KfCardInfo"] = {
            ["keys"] = {"mid","props"},
            ["fmt"]  = {"i","&$Property&"}
        },
        ["Rank1v1UInfo"] = {
            ["keys"] = {"roleId","roleName","sPre","sex","power","roleDw","pointShu"},
            ["fmt"]  = {"L","S","S","i","i","i","i"}
        },
        ["Rank1v1LogInfo"] = {
            ["keys"] = {"createTime","selfName","tarName","selfWin","selfPoint"},
            ["fmt"]  = {"i","S","S","i","i"}
        },
        ["Rank1v1RankInfo"] = {
            ["keys"] = {"roleId","roleName","index","vipLevel","roleIcon","power","pointShu","roleDw"},
            ["fmt"]  = {"L","S","i","i","i","i","i","i"}
        },
        ["WorldBossRankInfo"] = {
            ["keys"] = {"playerName","damage","rank"},
            ["fmt"]  = {"S","S","i"}
        },
        ["TickeyUser"] = {
            ["keys"] = {"rank","gotZs","roleName","tickey"},
            ["fmt"]  = {"i","i","S","i"}
        },
        ["LuckyBag"] = {
            ["keys"] = {"amount","libId","mid"},
            ["fmt"]  = {"i","i","i"}
        }
  }
}

return MsgDef