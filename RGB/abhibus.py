def get_result_text(result) -> str:
    try:
        return result.find_element_by_class_name('TravelAgntNm ng-binding').text
    except:
        return ""
def get_result_price(result) -> str:
    try:
        return result.find_element_by_class_name('TickRate ng-binding').text
    except:
        return ""
def get_result_moneysymbol(result) -> str:
    try:
        return result.find_element_by_class_name('WebRupee').text
    except:
        return ""
def get_result_start_time(result) -> str:
    try:
        return result.find_element_by_class_name('StrtTm tooltipsteredBoarding ng-binding tooltipstered').text
    except:
        return ""
def get_result_end_time(result) -> str: 
    try: 
        return result.find_element_by_class_name('ArvTm tooltipsteredDropping ng-binding tooltipstered').text
    except:
        return ""
def get_result_rating(result) -> str:
    try:
        return result.find_element_by_class_name('rating-sec ng-binding').text
    except:
        return ""