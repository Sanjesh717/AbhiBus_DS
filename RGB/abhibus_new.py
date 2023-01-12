def get_result_text(result) -> str:
    try:
        for items in result:
            get_result_text = items.find_element_by_xpath("//h2[contains(@class, 'TravelAgntNm ng-binding'")
            return (get_result_text.text)
    except:
        return ""
            
def get_result_price(result) -> str:
    try:
        for items in result:
            get_result_price = items.find_element_by_xpath("//strong[contains(@class, 'TickRate ng-binding'")
            return (get_result_price.text)
    except:
        return ""

def get_result_start_time(result) -> str:
    try:
        for items in result:
            get_result_start_time = items.find_element_by_xpath("//span[contains(@class, 'StrtTm tooltipsteredBoarding ng-binding tooltipstered'")
            return (get_result_start_time.text)
    except:
        return ""

def get_result_end_time(result) -> str:
    try:
        for items in result:
            get_result_end_time = items.find_element_by_xpath("//span[contains(@class, 'StrtTm tooltipsteredBoarding ng-binding tooltipstered'")
            return (get_result_end_time.text)
    except:
        return ""
            
def get_result_rating(result) -> str:
    try:
        for items in result:
            get_result_rating = items.find_element_by_xpath("//span[contains(@class, 'rating-sec ng-binding'")
            return (get_result_rating.text)
    except:
        return ""