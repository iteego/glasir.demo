<%-- 
  This page displays size chart for:
    Women's Shirt;
    Men's Shirt;
    Women's Shoes;
    Men's Shoes.
 --%>
<dsp:page>

  <crs:popupPageContainer divId="atg_store_sizeChart"
    titleKey="browse_sizeChart.title"
    useCloseImage="false">

    <%-- Women's Shirt sizes --%>
    <table id="atg_store_sizeChartTable">
      <tbody>
        <tr class="atg_store_sizeChartType">
          <td colspan="8"><fmt:message key="browse_sizeChart.womenShirt" /></td>
        </tr>
        <tr class="atg_store_sizeChartSizes">
          <th class="arg_store_sizeChartRowTitle"><fmt:message key="browse_sizeChart.usSize" /></th>
          <th><fmt:message key="browse_sizeChart.usSize" /></th>          
          <th><fmt:message key="browse_sizeChart.euSize" /></th>          
          <th><fmt:message key="browse_sizeChart.bust" /></th>
          <th><fmt:message key="browse_sizeChart.sleeve" /></th>
          <th><fmt:message key="browse_sizeChart.waist" /></th>
          <th><fmt:message key="browse_sizeChart.hip" /></th>
          <th><fmt:message key="browse_sizeChart.inseam" /></th>
        </tr>
        
        <tr>
          <td>0</td>
          <td>S</td>
          <td>30</td>
          <td>31"</td>
          <td>29 3/8"</td>
          <td>24"</td>
          <td>33"</td>
          <td>33"</td>
        </tr>
        <tr>
          <td>2</td>
          <td>S</td>
          <td>32</td>
          <td>32"</td>
          <td>29 3/8"</td>
          <td>25"</td>
          <td>34"</td>
          <td>33"</td>
        </tr>
        <tr>
          <td>4</td>
          <td>M</td>
          <td>34</td>
          <td>33"</td>
          <td>30"</td>
          <td>26"</td>
          <td>35"</td>
          <td>33"</td>
        </tr>
        <tr>
          <td>6</td>
          <td>M</td>
          <td>36</td>
          <td>34"</td>
          <td>31"</td>
          <td>27"</td>
          <td>36"</td>
          <td>33"</td>
        </tr>
        <tr>
          <td>8</td>
          <td>L</td>
          <td>38</td>
          <td>35"</td>
          <td>31 1/2"</td>
          <td>28"</td>
          <td>37"</td>
          <td>33"</td>
        </tr>
        <tr>
          <td>10</td>
          <td>L</td>
          <td>40</td>
          <td>36"</td>
          <td>32 1/8"</td>
          <td>29"</td>
          <td>38"</td>
          <td>33"</td>
        </tr>
        <tr>
          <td>12</td>
          <td>XL</td>
          <td>42</td>
          <td>37"</td>
          <td>32 3/8"</td>
          <td>30 1/2"</td>
          <td>39"</td>
          <td>33"</td>
        </tr>
        <tr>
          <td>14</td>
          <td>XXL</td>
          <td>44</td>
          <td>38"</td>
          <td>32 5/8"</td>
          <td>32"</td>
          <td>40 1/2"</td>
          <td>33"</td>
        </tr>
      </tbody>
    </table>
    
    
    <%-- Men's Shirt sizes --%>
    <table id="atg_store_sizeChartTable">
      <tbody>
        <tr class="atg_store_sizeChartType">
          <td colspan="6"><fmt:message key="browse_sizeChart.menShirt" /></td>
        </tr>
        <tr class="atg_store_sizeChartSizes">
          <th class="arg_store_sizeChartRowTitle"><fmt:message key="browse_sizeChart.usSize" /></th>
          <th><fmt:message key="browse_sizeChart.euSize" /></th>
          <th><fmt:message key="browse_sizeChart.neck" /></th>
          <th><fmt:message key="browse_sizeChart.chest" /></th>
          <th><fmt:message key="browse_sizeChart.waist" /></th>
          <th><fmt:message key="browse_sizeChart.sleeve" /></th>
        </tr>
        <tr>
          <td>S</td>
          <td>87</td>
          <td>14-14"</td>
          <td>34-36"</td>
          <td>28-30"</td>
          <td>32-33"</td>
        </tr>
        <tr>
          <td>M</td>
          <td>91</td>
          <td>15-15"</td>
          <td>38-40"</td>
          <td>32-34"</td>
          <td>33-34"</td>
        </tr>
        <tr>
          <td>L</td>
          <td>102</td>
          <td>16-16"</td>
          <td>42-44"</td>
          <td>36-38"</td>
          <td>34-35"</td>
        </tr>
        <tr>
          <td>XL</td>
          <td>107</td>
          <td>17-17"</td>
          <td>42-44"</td>
          <td>40-42"</td>
          <td>35-35"</td>
        </tr>
        <tr>
          <td>XXL</td>
          <td>117</td>
          <td>18-18"</td>
          <td>50-52"</td>
          <td>44-46"</td>
          <td>35-36"</td>
        </tr>
      </tbody>
    </table>

    <%-- Women's Shoes sizes --%>
    <table id="atg_store_sizeChartTable">
      <tbody>
        <tr class="atg_store_sizeChartType">
          <td colspan="5"><fmt:message key="browse_sizeChart.womenShoes" /></td>
        </tr>
        <tr class="atg_store_sizeChartSizes">
          <th class="arg_store_sizeChartRowTitle"><fmt:message key="browse_sizeChart.us" /></th>
          <th><fmt:message key="browse_sizeChart.uk" /></th>
          <th><fmt:message key="browse_sizeChart.eu" /></th>
          <th><fmt:message key="browse_sizeChart.jp" /></th>
          <th><fmt:message key="browse_sizeChart.mx" /></th>
        </tr>
        <tr>
          <td>5</td>
          <td>3 1/2</td>
          <td>35 1/2</td>
          <td>22</td>
          <td>3</td>
        </tr>
        <tr>
          <td>5 1/2</td>
          <td>4</td>
          <td>36</td>
          <td>22 1/2</td>
          <td>3 1/2</td>
        </tr>
        <tr>
          <td>6</td>
          <td>4 1/2</td>
          <td>36 1/2</td>
          <td>23</td>
          <td>4</td>
        </tr>
        <tr>
          <td>6 1/2</td>
          <td>5</td>
          <td>37</td>
          <td>23 1/2</td>
          <td>4 1/2</td>
        </tr>
        <tr>
          <td>7</td>
          <td>5 1/2</td>
          <td>37 1/2</td>
          <td>24</td>
          <td>5</td>
        </tr>
        <tr>
          <td>7 1/2</td>
          <td>6</td>
          <td>38</td>
          <td>24 1/2</td>
          <td>5 1/2</td>
        </tr>
        <tr>
          <td>8</td>
          <td>6 1/2</td>
          <td>38 1/2</td>
          <td>25</td>
          <td>6</td>
        </tr>
        <tr>
          <td>8 1/2</td>
          <td>7</td>
          <td>39</td>
          <td>25 1/2</td>
          <td>6 1/2</td>
        </tr>
        <tr>
          <td>9</td>
          <td>7 1/2</td>
          <td>39 1/2</td>
          <td>26</td>
          <td>7</td>
        </tr>
        <tr>
          <td>9 1/2</td>
          <td>8</td>
          <td>40</td>
          <td>26 1/2</td>
          <td>7 1/2</td>
        </tr>
        <tr>
          <td>10</td>
          <td>8 1/2</td>
          <td>40 1/2</td>
          <td>27</td>
          <td>8</td>
        </tr>
      </tbody>
    </table>
    
    <%-- Men's Shoes sizes --%>
    <table id="atg_store_sizeChartTable">
      <tbody>
        <tr class="atg_store_sizeChartType">
          <td colspan="5"><fmt:message key="browse_sizeChart.menShoes" /></td>
        </tr>
        <tr class="atg_store_sizeChartSizes">
          <th class="arg_store_sizeChartRowTitle"><fmt:message key="browse_sizeChart.us" /></th>
          <th><fmt:message key="browse_sizeChart.uk" /></th>
          <th><fmt:message key="browse_sizeChart.eu" /></th>
          <th><fmt:message key="browse_sizeChart.jp" /></th>
          <th><fmt:message key="browse_sizeChart.mx" /></th>
        </tr>
        <tr>
          <td>8</td>
          <td>6 1/2</td>
          <td>41 1/2</td>
          <td>25</td>
          <td>7</td>
        </tr>
        <tr>
          <td>8 1/2</td>
          <td>7</td>
          <td>42</td>
          <td>25 1/2</td>
          <td>7 1/2</td>
        </tr>
        <tr>
          <td>9</td>
          <td>7 1/2</td>
          <td>42 1/2</td>
          <td>26</td>
          <td>8</td>
        </tr>
        <tr>
          <td>9 1/2</td>
          <td>8</td>
          <td>43</td>
          <td>26 1/2</td>
          <td>8 1/2</td>
        </tr>
        <tr>
          <td>10</td>
          <td>8 1/2</td>
          <td>43 1/2</td>
          <td>27</td>
          <td>9</td>
        </tr>
        <tr>
          <td>10 1/2</td>
          <td>9</td>
          <td>44</td>
          <td>27 1/2</td>
          <td>9 1/2</td>
        </tr>
        <tr>
          <td>11</td>
          <td>9 1/2</td>
          <td>44 1/2</td>
          <td>28</td>
          <td>10</td>
        </tr>
        <tr>
          <td>11 1/2</td>
          <td>10</td>
          <td>45</td>
          <td>28 1/2</td>
          <td>10 1/2</td>
        </tr>
        <tr>
          <td>12</td>
          <td>10 1/2</td>
          <td>45 1/2</td>
          <td>29</td>
          <td>11</td>
        </tr>
        <tr>
          <td>12 1/2</td>
          <td>11</td>
          <td>46</td>
          <td>29 1/2</td>
          <td>11 1/2</td>
        </tr>
        <tr>
          <td>13</td>
          <td>11 1/2</td>
          <td>46 1/2</td>
          <td>30</td>
          <td>12</td>
        </tr>
      </tbody>
    </table>
    
  </crs:popupPageContainer>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.0.2/Storefront/j2ee/store.war/browse/gadgets/sizeChart.jsp#1 $$Change: 633540 $--%>

