@read_scandi_data_align_sitecode_filename
@date2scandi_config
@FSC_color
@winsorise_percent_scandiFormatData

; This program can loop over all data from all seasons of SCANDI's operation
; (2007-present), however this is not advisable as the map plot pages are 
; fairly large files - they are advised to be created on a case by case basis.
;
; The data is plotted in map plot format with 26 exposures per page lined up in
; 3 rows:
; top row = LOS wind data in blue
; middle row = neutral temperature data in green
; bottom row = relative intensity data in red
;
; The data is winsorised for each parameter all together (all zones and all
; exposures) so that each page of 26 exposures has the same scale of data 
; (shown in colorbar at the centre).

PRO map_plot_general_Apr16

;;;;;;;;;;;;;;;;;INPUTS HERE;;;;;;;;;;;;;;;;;;;;
yr_st = '13'      ;DIRECTORY/SEASON YRS - accepts any year from the
yr_ed = '13'	  ;set ['07','08','09','10','11','12','13','14','15',...]
mth_st = '2'      ;Month from set [9, A, B, C, 1, 2, 3, 4] 
mth_ed = '2'      ;1 refers to Jan in nxt actual yr but same season
num_day = 1       ;# of days in the month to analyse from st_day (max=31)
st_day = 21       ;The first day in the month to be analysed
para = 'SKY' 	  ;Type of data to be analysed - ['SKY', 'CAL','LAS']
                  ;N.B. LAS does not work, cannot fit Gaussian to thin peak.
MLTorUT='UT'  	  ;Set to plot MLT or UT
sitecode_desired = 'W'	;From set ['W' or 'Y' or 'ALL'] for red or green line
nzones_desired = '61'	;From set ['25','51','61','91','ALL']

percent_winsorise = 90	;90% => <5th & >95th percentile goes to
			;	5th & 95th percentile
ishift = -50	 ;starts ~23UT, ends ~25UT
; ishift = 0	 ;starts ~ 32UT to ~35 UT default CAN MANUALLY CHANGE START TIME HERE
scale_perPage_flag = 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;FIND HOW MANY MONTHS AND DAYS TO LOOP OVER
month_set = ['9', 'A', 'B', 'C', '1', '2', '3', '4']
year_set = ['07','08','09','10','11','12','13','14','15', '16','17',$
            '18', '19', '20','21','22']
month_set_nums = ['9', '10', '11', '12', '1', '2', '3', '4']

imth_st = where(month_set eq mth_st)
imth_ed = where(month_set eq mth_ed)
imth_st = imth_st[0]
imth_ed = imth_ed[0]
nmth = imth_ed-imth_st+1

iyr_st = where(year_set eq yr_st)
iyr_ed = where(year_set eq yr_ed)
iyr_st = iyr_st[0]
iyr_ed = iyr_ed[0]
nyr = iyr_ed-iyr_st+1

;LOG TRACK OF PROGRAM
print,';;;;Start of program;;;;'
print,'YEARS:',yr_st+'-'+yr_ed
print,'   Months:',mth_st+'-'+mth_ed

;LOOP AROUND DIFFERENT YEARS, MONTHS AND DAYS
for iyr = iyr_st, iyr_ed do begin

   yr = year_set[iyr]
   help,yr              ;Helps keep track of routine progress

   data_dir = yr

   for imth = imth_st, imth_ed do begin


      mth = month_set[imth]
      mth_num_str = month_set_nums[imth]

      help,mth     ;Helps keep track of routine progress


      ;SORT OUT THE MONTH NAMES FOR THE FILENAMES AND THE DIRECTORIES
      if (mth ne 'A') and (mth ne 'B') and (mth ne 'C') then begin
          if (float(mth) lt 6) then $
             yr_file = string(float(yr)+1,format='(I2.2)')
      endif

      if mth eq 'A' or mth eq 'B' or mth eq 'C' or mth eq '9' then begin
         if mth eq 'A' then mth_num = 10
         if mth eq 'B' then mth_num = 11
         if mth eq 'C' then mth_num = 12
         if mth eq '9' then mth_num = 9
         yr_file = yr
      endif else begin
         mth_num = float(mth)
      endelse

      year = float(yr_file)

      ;CREATE THE DAY ARRAY
      days = Indgen(num_day)+st_day ;Create the day array

      for ifilename_date = 0, num_day-1 do begin


	  ;;;;;;;;;;;;;DATA READ-IN AND ARRAY SET-UP SECTION;;;;;;;;;;;;;;;;
          day = days[ifilename_date]
          day_str = string(day,format='(I2.2)')

	  day2 = day+1
	  day2_str = string(day2,format='(I2.2)')

          dy = float(day_str)
          date = day_str+'/'+mth_num_str+'/'+yr

          date2scandi_config, dy, mth_num, year, nzone_str, sitecode, lambda0,$
	;			 align_para, act_para, dat_good, info_str, north_zone_from_geog
				 align_para, act_para, dat_good, info_str

	  ;SOME ERROR MESSAGES
          if dat_good eq 0 then begin
                    print, 'Data not good quality'
                    print, info_str
                    continue
          endif
          if sitecode_desired ne 'ALL' then begin
	    if sitecode ne sitecode_desired then begin
                print, 'sitecode_desired not running at this'+$
				' date (diff emission line)'
                continue
            endif
	  endif
          if nzones_desired ne 'ALL' then begin
	    if nzone_str ne nzones_desired then begin
		print, 'nzones_desired not the configuration at this date'
		continue
	    endif
	  endif

          nzone = float(nzone_str)
	  zones = findgen(nzone)+1

          fname='/import/apl-data/fpi/'+sitecode+data_dir+'/'+sitecode+$
			act_para+align_para+yr_file+mth+day_str+'SKY.dat'
          if file_test(fname) eq 1 then print, fname

          ; THIS CAN BE HARDWIRED TO '0' IF DO NOT WANT TO ACTUALLY READ IN
	  ; AND BIN DATA (BULK OF ROUTINE) AND JUST WANT TO EXECUTE WRAPPER
	  ; PROGRAMME, E.G., TO PRINT OUT INFO_STR OF ERRONEOUS FILE
          go_thru_analysis = 1
          if go_thru_analysis eq 1 then begin

		;READ-IN AND PREPARE DATA
		read_scandi_data_align_sitecode_filename, fname, sitecode,$
		 	num_exp, site, zone_num, em_line, date, time_fin, In,$
			In_err, Un, Un_err, Tn, Tn_err, sig2noise, open_error

		if open_error ne 0 then stop

		;REMOVE ANOMALOUS 'H1' IMAGES TAKEN 1 MIN AFTER A NORMAL IMAGE
		;TO TEST FOR HIBERNATION
		dt = fltarr(num_exp)
		for i = 1,num_exp-1 do dt[i] = time_fin[i]-time_fin[i-1]
		dt[0] = 7.3/60    ;Set this to nominal dt value, assume 1st exposure fine
		h1where = where(dt gt (2./60))

		num_exp = n_elements(h1where)
		time_fin = time_fin(h1where)
		In = In(*,h1where)
		In_err = In_err(*,h1where)
		Un = Un(*,h1where)
		Un_err = Un_err(*,h1where)
		Tn = Tn(*,h1where)
		Tn_err = Tn_err(*,h1where)

		;CALLIBRATE INTENSITIES
	        if nzone eq 61 then begin
		   ;Multiply intensities with the worked out Io/I on a few
		   ;quiet night (Ap=0)
		   for zon = 0,nzone-1 do begin
		      for n_exp=0,num_exp-1 do begin
			if zon eq 0 then $
				In(zon,n_exp) = In(zon,n_exp)*1
			if zon gt 0 and zon lt 7 then $
				In(zon,n_exp) = In(zon,n_exp)*1.04
			if zon gt 6 and zon lt 25 then $
				In(zon,n_exp) = In(zon,n_exp)*1.25
			if zon gt 24 and zon lt 43 then $
				In(zon,n_exp) = In(zon,n_exp)*1.67
			if zon gt 42 and zon lt 61 then $
				In(zon,n_exp) = In(zon,n_exp)*2.10
		      endfor
	  	   endfor
		endif else begin	;For other zone maps, use more crude
					;method averaging over this 1 night
		   calibrate_scandi_intensities, In	
		endelse					


		;SET PARAMETER NAMES
		ct = num_exp
		data = fltarr(3,nzone,num_exp)
		para_names = ['Un','Tn','In']
		data[0,*,*] = Un
		data[1,*,*] = Tn
		data[2,*,*] = In
		ytsets = ['LOS Wind, m/s, + away','Temperature, K',$
						'Relative Intensity']

		;SORT OUT TIME STUFF
		time_sca = reform(time_fin)
		if MLTorUT eq 'MLT' then $
			time_sca = time_sca + 3.07 else time_sca = time_sca

		hr_num = fix(time_sca)
		min_num = round((time_sca-hr_num)*60)

		;If mins = 60 then hour = hour+1, min=00
		for i=0,num_exp-1 do begin
			if min_num[i] eq 60 then begin
				hr_num[i]=hr_num[i]+1
				min_num[i]=0
			endif
		endfor

		hr_str=string(hr_num,format='(I2.2)')
		min_str=string(min_num,format='(I2.2)')

		;SET UP THE nstamp TIME RANGES MAKING THE WHOLE DURATION OF THE NIGHT
		nstamp = ceil(num_exp/26.)	;26 plots per page
		time_stamp_bg = fltarr(nstamp)	;Array for 1st plot on page time index/stamp
		time_stamp_ed = fltarr(nstamp)	;Array for last plot on page time index
		time_stamp_bg(0:nstamp-2) = Indgen(nstamp-1)*26
		time_stamp_ed(0:nstamp-2) = 25+Indgen(nstamp-1)*26
		time_stamp_bg[nstamp-1] = num_exp-26	;Last page, exposures displayed will
		time_stamp_ed[nstamp-1] = num_exp-1	;probably overlap with page before if
		ntime_stamp = nstamp			;exposures not a multiple of 26


		;MAPPING DATA TO CORRECT ZONE ON FOV - MAKE A GRID
		;Externally make a grid.dat in this directory i.e. a grid of 200x200 boxes
		;which encases SCANDI's FOV. Each box corresponds to the number zone which is
		;mapped onto it. If outside FOV made a ridiculous number.
		grid_200x200 = fltarr(200,200)
		if nzone eq 51 then begin
		   print,'no grid200x200 for 51 zones - write a grid_hunter_51.pro'
		endif
		if nzone eq 25 then openr, 1, 'grid200x200_25.dat'
		if nzone eq 61 then openr, 1, 'grid200x200_61.dat'
		if nzone eq 91 then openr, 1, 'grid200x200_91.dat'

		   for i = 0,199 do begin
			x = fltarr(200)
			readf, 1, x
			grid_200x200(i,*) = x
		    endfor
		close, 1

		;CREATE THE GRIDS FOR PLOTTING & INITIALLY FILL WITH EMPTY DATA VALS
		;a number outside the range of plotting data
		empty_no = -9999
		grid_data = fltarr(3,200,200)
		grid_data(*,*,*) = empty_no

		;WINSORISE THE DATA TO REMOVE OUTLIERS AND MAKE THE REGIONS OF THE
		;MAP PLOT MORE DISTINCT - REPLACE POINTS > A CERTAIN PERCENTILE AWAY FROM
		;THE MEAN WITH THE PERCENTILE VALUE
		;percent_winsorise =>defined in inputs at top of script
		for ipara = 0,2 do begin

		      data_ipara = reform(data[ipara,*,*])
		      winsorise_percent_scandiFormatData, data_ipara, percent_winsorise, data_winsorised
		      data[ipara,*,*] = data_winsorised

		endfor	;END LOOP OVER DIFFERENT PARAMETERS

		;;;WIND BASELINE - NOW FOUND OUTLIERS, CAN REMOVE ZONAL BASELINE
		for izone = 0, nzone -1 do begin
		       mean_Un_zone = mean(data[0, izone,*])
		       data[0, izone,*] = data[0, izone,*]-mean_Un_zone
		endfor

		;SET NUMBER OF LEVELS - WUSED FOR THE CONTOUR PLOT AND COLORBAR
		levels=30.0

		;FIND MIN AND MAX OF ALL DATA (FOR CONTOUR INTERVAL AND COLORBAR LIMITS)
		max_dat = fltarr(3)
		min_dat = fltarr(3)
		for ipara = 0,2 do max_dat[ipara] = max(data[ipara,*,*])
		for ipara = 0,2 do min_dat[ipara] = min(data[ipara,*,*])
		print,'max',max_dat
		print,'min',min_dat

		;FIND DIVISION VALUES OF N LEVELS
		steps = (max_dat-min_dat)/levels
		levels_data = transpose([[IndGen(levels)], [IndGen(levels)],[IndGen(levels)]])
		help,levels_data
		for ipara = 0,2 do levels_data[ipara,*] = levels_data[ipara,*]*steps[ipara]+min_dat[ipara]

		;LOOP OVER 7 DIFFERENT CHUNKS OF TIME ([0,6] usually), can hardwire if necessary
		for itime_stamp = ntime_stamp-2, ntime_stamp-1 do begin

		    ;CAN MANUALLY CHANGE START TIME HERE - otherwise run through all sets of 26 plots
		    itime_bg=time_stamp_bg(itime_stamp)+ishift
		    itime_ed=time_stamp_ed(itime_stamp)+ishift

		    print,'time_bg',time_sca(itime_bg)
		    print,'time_ed',time_sca(itime_ed)

		    ;PLOT POSITIONS
		    ;p1 = x-axis postions, varies with time stamp
		    p1 = 0.0155+Indgen(13)*0.074
		    p1_all = fltarr(num_exp)
		    p1_all(*) = 0.0
		    p1_all[(itime_bg):(itime_bg+12)] = p1   ;1st row of plots
		    p1_all[(itime_bg+13):(itime_ed)] = p1    ;2nd row of plots

		    ;p3 = x-axis positions, varies with time stamp
		    p3 = 0.955+Indgen(13)*0.074
		    p3_all = fltarr(num_exp)
		    p3_all(*) = 0.0
		    p3_all[(itime_bg):(itime_bg+12)] = p3
		    p3_all[(itime_bg+13):(itime_ed)] = p3

		    ;p2 and p4 = y-axis positions, constant with time
		    p2a=reverse(0.66+Indgen(3)*0.10)
		    p2b=reverse(0.04+Indgen(3)*0.10)
		    p4a=reverse(0.76+Indgen(3)*0.10)
		    p4b=reverse(0.14+Indgen(3)*0.10)

                    if scale_perPage_flag eq 1 then begin

                       ;FIND MIN AND MAX OF ALL DATA (FOR CONTOUR INTERVAL AND COLORBAR LIMITS)
                       max_dat = fltarr(3)
                       min_dat = fltarr(3)
                       for ipara = 0,2 do max_dat[ipara] = max(data[ipara,*,itime_bg:itime_ed])
                       for ipara = 0,2 do min_dat[ipara] = min(data[ipara,*,itime_bg:itime_ed])
                       print,'max',max_dat
                       print,'min',min_dat
       
                       ;FIND DIVISION VALUES OF N LEVELS
                       steps = (max_dat-min_dat)/levels
                       levels_data = transpose([[IndGen(levels)], [IndGen(levels)],[IndGen(levels)]])
                       help,levels_data
                       for ipara = 0,2 do levels_data[ipara,*] = levels_data[ipara,*]*steps[ipara]+min_dat[ipara]
   
                    endif


		    ;SET PLOT
		    set_plot, 'PS'

		    white = FSC_color("white",1)
		    black = FSC_color("black",2)
		    grey=FSC_color("light gray",3)
		    Loadct, 13, NCOLORS=levels, Bottom=0,/silent

		   ; filename='/home/amy/plots/map/'+sitecode+act_para+align_para+$
		    filename='/import/apl-data/fpi/'+sitecode+data_dir+'/'+sitecode+act_para+align_para+$
		      yr_file+mth+day_str+'SKY'+$
		      'map'+hr_str[itime_bg]+min_str[itime_bg]+'.ps'

		    print, filename

		    device, file=filename, /color, /landscape


		    for itime = itime_bg, itime_ed do begin

			;Change time later than midnight to be from 00:00-12:00
			if hr_num(itime) ge 24 then begin
				plot_hr = string(hr_num(itime)-24,format='(I2.2)')
			endif else begin
				plot_hr = hr_str(itime)
			endelse

			;SET POSITIONS FOR THE SECOND ROW OF DATA
			if itime lt (itime_bg + 13) then begin
			    p2=p2a
			    p4=p4a
			endif else begin
			    p2=p2b
			    p4=p4b
			endelse

			;INSERT DATA INTO EMPTY GRID_DATA ARRAY        
			for ipara = 0,2 do for ix = 0, 199 do begin
			    for iy = 0, 199 do begin
				zone_num = fix(grid_200x200(ix,iy))
				if zone_num gt 0 then begin
				    grid_data(ipara,ix,iy) = data(ipara,zone_num-1,itime)
				endif
			    endfor
			endfor

			;;;;;;;;;;CONTOUR PLOTS;;;;;;;;;;
			ct_cols = [1, 8, 3]
			tstrings = [plot_hr+':'+min_str(itime),'','']

			for ipara = 0,2 do begin
			    loadct, ct_cols[ipara], ncolors = levels, bottom = 0, /silent
			    contour, grid_data[ipara,*,*], /fill , c_colors = indgen(levels)+0, background = white, $
				levels = levels_data[ipara,*], XTICKFORMAT = "(A1)", YTICKFORMAT = "(A1)",$
				position = [p1_all(itime), p2(ipara), p3_all(itime), p4(ipara)],$
				color = black, xs=1, ys=1,$
				title = tstrings[ipara], $
				/isotropic, /noerase

			    ;This countour overplot draws boundaries around the filled contour plot
			    contour, grid_data[ipara,*,*], /overplot, levels = levels_data[ipara,*], c_linestyle = 1,$
				Color=black,thick=0.1

			endfor	;END LOOP OVER DIFFERENT PARAMETERS

		    endfor	;END LOOP OVER DIFFERENT TIME STAMPS

		    ;COLOUR BARS
		    ;Draw a colorbar, need colorbar.pro
		    positions = transpose([[0.05, 0.595, 0.95, 0.615],[0.05, 0.51, 0.95, 0.53],$
						[0.05, 0.425, 0.95, 0.445]])
		    for ipara = 0,2 do begin
		       loadct, ct_cols[ipara], NCOLORS=(levels*10), Bottom=0, /silent
		       colorbar, $
			  bottom = 0, Divisions = 10, $
			  min = min_dat[ipara], max = max_dat[ipara] , Format='(I10)',$ 
			  position = positions[ipara,*], Color = black, $
			  title = ytsets[ipara], charsize = 0.9
		    endfor

           ;     ADD HEADER
                percent_winsorise_str = string(percent_winsorise,format ='(I0)')
                if percent_winsorise ne 100 then begin
                    xyouts, 0.5, 1, 'SCANDI '+lambda0+STRING(197B)+'  -  '+$
                                    day_str+'-'+day2_str+'/'+mth_num_str+'/' +yr_file+$
                                    '  -  time in '+MLTorUT+',  '+percent_winsorise_str+$
                                    '% winsorisation', /normal, alignment = 0.5
                endif else begin
                    xyouts, 0.5, 1, 'SCANDI '+lambda0+STRING(197B)+'  -  '+$
                        day_str+'-'+day2_str+'/'+mth_num_str+'/' +yr_file+$
                        '  -  time in '+MLTorUT, /normal, alignment = 0.5
                endelse

                ;North Orientation title
;                xyouts,0.25, -0.03,'N!ISCANDI!N = '+north_zone_from_geog+$
;                              '!18_!6 clockwise'+' of N!IGEOGRAPHIC!N',$
;                              /normal,charsize = 1.2, alignment = 0, charthick = 2

		    device,/close

		endfor		;END LOOP OVER DIFFERENT 26 CHUNKS OF TIME STAMPS


          endif   ;IF WHETHER TO DO ANALYSIS OR JUST RUN WRAPPER


      endfor    ;END LOOP OVER DIFFERENT FILES

   endfor       ;END LOOP OVER DIFF MONTHS

endfor  ;END LOOP OVER DIFF YEARS

stop

END
