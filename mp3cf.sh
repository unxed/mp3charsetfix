#!/bin/bash

# Function to determine encoding based on system locale
# Функция для определения кодировки на основе системной локали
get_encoding() {
    local locale="$1"
    declare -A lcToAnsiTable=(
        ["af_ZA"]="CP1252" ["ar_SA"]="CP1256" ["ar_LB"]="CP1256" ["ar_EG"]="CP1256"
        ["ar_DZ"]="CP1256" ["ar_BH"]="CP1256" ["ar_IQ"]="CP1256" ["ar_JO"]="CP1256"
        ["ar_KW"]="CP1256" ["ar_LY"]="CP1256" ["ar_MA"]="CP1256" ["ar_OM"]="CP1256"
        ["ar_QA"]="CP1256" ["ar_SY"]="CP1256" ["ar_TN"]="CP1256" ["ar_AE"]="CP1256"
        ["ar_YE"]="CP1256" ["ast_ES"]="CP1252" ["az_AZ"]="CP1251" ["az_AZ"]="CP1254"
        ["be_BY"]="CP1251" ["bg_BG"]="CP1251" ["br_FR"]="CP1252" ["ca_ES"]="CP1252"
        ["zh_CN"]="CP936"  ["zh_TW"]="CP950"  ["kw_GB"]="CP1252" ["cs_CZ"]="CP1250"
        ["cy_GB"]="CP1252" ["da_DK"]="CP1252" ["de_AT"]="CP1252" ["de_LI"]="CP1252"
        ["de_LU"]="CP1252" ["de_CH"]="CP1252" ["de_DE"]="CP1252" ["el_GR"]="CP1253"
        ["en_AU"]="CP1252" ["en_CA"]="CP1252" ["en_GB"]="CP1252" ["en_IE"]="CP1252"
        ["en_JM"]="CP1252" ["en_BZ"]="CP1252" ["en_PH"]="CP1252" ["en_ZA"]="CP1252"
        ["en_TT"]="CP1252" ["en_US"]="CP1252" ["en_ZW"]="CP1252" ["en_NZ"]="CP1252"
        ["es_PA"]="CP1252" ["es_BO"]="CP1252" ["es_CR"]="CP1252" ["es_DO"]="CP1252"
        ["es_SV"]="CP1252" ["es_EC"]="CP1252" ["es_GT"]="CP1252" ["es_HN"]="CP1252"
        ["es_NI"]="CP1252" ["es_CL"]="CP1252" ["es_MX"]="CP1252" ["es_ES"]="CP1252"
        ["es_CO"]="CP1252" ["es_PE"]="CP1252" ["es_AR"]="CP1252" ["es_PR"]="CP1252"
        ["es_VE"]="CP1252" ["es_UY"]="CP1252" ["es_PY"]="CP1252" ["et_EE"]="CP1257"
        ["eu_ES"]="CP1252" ["fa_IR"]="CP1256" ["fi_FI"]="CP1252" ["fo_FO"]="CP1252"
        ["fr_FR"]="CP1252" ["fr_BE"]="CP1252" ["fr_CA"]="CP1252" ["fr_LU"]="CP1252"
        ["fr_MC"]="CP1252" ["fr_CH"]="CP1252" ["ga_IE"]="CP1252" ["gd_GB"]="CP1252"
        ["gv_IM"]="CP1252" ["gl_ES"]="CP1252" ["he_IL"]="CP1255" ["hr_HR"]="CP1250"
        ["hu_HU"]="CP1250" ["id_ID"]="CP1252" ["is_IS"]="CP1252" ["it_IT"]="CP1252"
        ["it_CH"]="CP1252" ["iv_IV"]="CP1252" ["ja_JP"]="CP932" ["kk_KZ"]="CP1251"
        ["ko_KR"]="CP949" ["ky_KG"]="CP1251" ["lt_LT"]="CP1257" ["lv_LV"]="CP1257"
        ["mk_MK"]="CP1251" ["mn_MN"]="CP1251" ["ms_BN"]="CP1252" ["ms_MY"]="CP1252"
        ["nl_BE"]="CP1252" ["nl_NL"]="CP1252" ["nl_SR"]="CP1252" ["nn_NO"]="CP1252"
        ["nb_NO"]="CP1252" ["pl_PL"]="CP1250" ["pt_BR"]="CP1252" ["pt_PT"]="CP1252"
        ["rm_CH"]="CP1252" ["ro_RO"]="CP1250" ["ru_RU"]="CP1251" ["sk_SK"]="CP1250"
        ["sl_SI"]="CP1250" ["sq_AL"]="CP1250" ["sr_RS"]="CP1251" ["sr_RS"]="CP1250"
        ["sv_SE"]="CP1252" ["sv_FI"]="CP1252" ["sw_KE"]="CP1252" ["th_TH"]="CP874"
        ["tr_TR"]="CP1254" ["tt_RU"]="CP1251" ["uk_UA"]="CP1251" ["ur_PK"]="CP1256"
        ["uz_UZ"]="CP1251" ["uz_UZ"]="CP1254" ["vi_VN"]="CP1258" ["wa_BE"]="CP1252"
        ["zh_HK"]="CP950" ["zh_SG"]="CP936"
    )
    echo "${lcToAnsiTable[$locale]}"
}

# Get the current locale
# Получение текущей локали
current_locale=$(locale | grep LANG= | cut -d= -f2 | cut -d. -f1)
encoding=$(get_encoding "$current_locale")

# Checking for necessary utilities
# Проверка наличия необходимых утилит
if ! command -v mid3iconv &> /dev/null; then
    echo "mid3iconv not found. Run 'sudo apt-get install python3-mutagen'."
    echo "mid3iconv не найден. Установка: 'sudo apt-get install python3-mutagen'."
    exit 1
fi

# Recursively search for mp3 files and process them
# Рекурсивный поиск mp3 файлов и их обработка
find . -type f -name "*.mp3" | while read -r file; do
    # Conversion from id3v1 to id3v2
    # Конвертация id3v1 в id3v2
    echo "$file ($encoding)"
    mid3iconv --remove-v1 -e "$encoding" "$file"
done
