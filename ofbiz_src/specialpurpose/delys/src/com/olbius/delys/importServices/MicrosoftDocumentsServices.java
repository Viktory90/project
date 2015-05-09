package com.olbius.delys.importServices;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Map;

import org.ofbiz.base.util.UtilGenerics;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.base.util.string.FlexibleStringExpander;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.DelegatorFactory;
import org.ofbiz.entity.GenericDelegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.hssf.record.PageBreakRecord.Break;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.Picture;
import org.apache.poi.util.IOUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.io.*;
import java.net.SocketException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;

@SuppressWarnings("unused")
public class MicrosoftDocumentsServices {
	public static String module = MicrosoftDocumentsServices.class.getName();
	public static final String resource = "DelysUiLabels";

	public static Map<String, Object> demoServices(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("productId");
		fieldToSelects.add("primaryProductCategoryId");
		fieldToSelects.add("internalName");
		fieldToSelects.add("weight");
		fieldToSelects.add("productUomId");
		Delegator delegator = ctx.getDelegator();
		List<String> orderBy = new ArrayList<String>();
		orderBy.add("primaryProductCategoryId");
		List<GenericValue> listProducts = delegator.findList("Product", null, fieldToSelects, orderBy, null, false);
		result.put("listDemo", listProducts);
		return result;
	}

	@SuppressWarnings("unchecked")
	public static void exportProductToExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
		GenericDelegator delegator = (GenericDelegator) DelegatorFactory.getDelegator("default");
		LocalDispatcher dispatcher = org.ofbiz.service.ServiceDispatcher.getLocalDispatcher("default", delegator);
		GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");
		
		Map<String, String[]> cntPram = request.getParameterMap();
		Map<String, Object> context = new HashMap<String, Object>();
		context.put("userLogin", userLogin);
		Map<String, Object> results = null;
		try {
			results = dispatcher.runSync("demoServices", context);
		} catch (GenericServiceException e) {
			e.printStackTrace();
		}
		List<GenericValue> listProducts = (List<GenericValue>) results.get("listDemo");
		if (UtilValidate.isEmpty(listProducts)) {
			response.flushBuffer();
		}
		Set<String> keyInGenericValue = listProducts.get(0).keySet();
		List<List<?>> listProduct = new FastList<List<?>>();
		for (GenericValue product : listProducts) {
			List<Object> thisProduct = new FastList<Object>();
			for (String key : keyInGenericValue) {
				thisProduct.add(product.get(key));
			}
			listProduct.add(thisProduct);
		}
		String sheetName = "San Pham";
		String fileName = "Danh Sach San Pham.xls";
		List<String> title = new FastList<String>();
		title.add("product Id");
		title.add("Product Category");
		title.add("internal Name");
		title.add("weight");
		title.add("Unit");
		Workbook wbProduct = renderProcessor(sheetName, fileName, title, listProduct);
//		ByteArrayOutputStream baos = new ByteArrayOutputStream();
//		try {
//			wbProduct.write(baos);
//			byte[] bytes = baos.toByteArray();
//			response.setHeader("content-disposition", "attachment;filename=" + fileName);
//			response.setContentType("application/vnd.xls");
//			response.getOutputStream().write(bytes);
//		} catch (SocketException e) {
//			e.printStackTrace();
//		} finally {
//			if(baos != null)baos.close();
//		}
		String file = "C:/Users/hoa/Desktop/test/test.xls";
        FileOutputStream out = new FileOutputStream(file);
        wbProduct.write(out);
        out.close();
	}

	private static Workbook renderProcessor(String sheetName, String fileName, List<String> titles, List<List<?>> data) throws IOException {
		Workbook wb = new HSSFWorkbook();
		Map<String, CellStyle> styles = createStyles(wb);
		Sheet sheet = wb.createSheet(sheetName);
		// turn off gridlines
		sheet.setDisplayGridlines(false);
		sheet.setPrintGridlines(false);
		sheet.setFitToPage(true);
		sheet.setHorizontallyCenter(true);
		PrintSetup printSetup = sheet.getPrintSetup();
		printSetup.setLandscape(true);

		sheet.setAutobreaks(true);
		printSetup.setFitHeight((short) 1);
		printSetup.setFitWidth((short) 1);

		Row imgHead = sheet.createRow(0);
		Cell imgCell = imgHead.createCell(0);
//		Row imgHead1 = sheet.createRow(1);
//		Cell imgCell1 = imgHead.createCell(0);
//		Row imgHead2 = sheet.createRow(2);
//		Cell imgCell2 = imgHead.createCell(0);
		int rownum = 0;
		FileInputStream  is = null;
		try {
			String imageServerPath = FlexibleStringExpander.expandString(UtilProperties.getPropertyValue("delys", "image.management.logoPath"), null);
			File file = new File(imageServerPath);
			is = new FileInputStream(file);
			byte[] bytesImg = IOUtils.toByteArray(is);
			int pictureIdx = wb.addPicture(bytesImg, Workbook.PICTURE_TYPE_PNG);
			CreationHelper helper = wb.getCreationHelper();
			Drawing drawing = sheet.createDrawingPatriarch();
			ClientAnchor anchor = helper.createClientAnchor();
			anchor.setCol1(0);
			anchor.setCol2(8);
			anchor.setRow1(0);
			anchor.setRow2(4);
			Picture pict = drawing.createPicture(anchor, pictureIdx);
			pict.getPreferredSize();
			rownum = 5;
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(is!=null)is.close();
		}
		Row titleRow = sheet.createRow(rownum);
		Cell titleCell = titleRow.createCell(1, 5);
		titleCell.setCellValue("COMMERCIAL CONTRACT");
		titleCell.setCellStyle(styles.get("title"));
		
		rownum += 1;
		Row headerRow = sheet.createRow(rownum);
		headerRow.setHeightInPoints(12.75f);
		rownum += 1;
		for (int i = 0; i < titles.size(); i++) {
			Cell cell = headerRow.createCell(i);
			cell.setCellValue(titles.get(i));
			cell.setCellStyle(styles.get("header"));
		}
//		sheet.createFreezePane(3, 4);
		Row row;
		Cell cell;
		for (int i = 0; i < data.size(); i++, rownum++) {
			row = sheet.createRow(rownum);
			List<?> thisRow = data.get(i);
			for (int j = 0; j < thisRow.size(); j++) {
				cell = row.createCell(j);
				String styleName = "cell_normal_centered";
				Object value = thisRow.get(j);
				cell.setCellValue(value.toString());
				cell.setCellStyle(styles.get(styleName));
			}
			sheet.autoSizeColumn(i);
		}
		sheet.setZoom(3, 4);
		return wb;
	}

	/**
	 * create a library of cell styles
	 */
	private static Map<String, CellStyle> createStyles(Workbook wb) {
		Map<String, CellStyle> styles = new HashMap<String, CellStyle>();
		DataFormat df = wb.createDataFormat();

		CellStyle style;
		Font headerFont = wb.createFont();
		headerFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setFont(headerFont);
		styles.put("header", style);
		
		Font titleFont = wb.createFont();
		titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
		titleFont.setFontHeight((short) 220);
		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setFont(titleFont);
		styles.put("title", style);
		
		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setFont(headerFont);
		style.setDataFormat(df.getFormat("d-mmm"));
		styles.put("header_date", style);

		Font font1 = wb.createFont();
		font1.setBoldweight(Font.BOLDWEIGHT_BOLD);
		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_LEFT);
		style.setFont(font1);
		styles.put("cell_b", style);

		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setFont(font1);
		styles.put("cell_b_centered", style);

		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_RIGHT);
		style.setFont(font1);
		style.setDataFormat(df.getFormat("d-mmm"));
		styles.put("cell_b_date", style);

		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_RIGHT);
		style.setFont(font1);
		style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setDataFormat(df.getFormat("d-mmm"));
		styles.put("cell_g", style);

		Font font2 = wb.createFont();
		font2.setColor(IndexedColors.BLUE.getIndex());
		font2.setBoldweight(Font.BOLDWEIGHT_BOLD);
		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_LEFT);
		style.setFont(font2);
		styles.put("cell_bb", style);

		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_RIGHT);
		style.setFont(font1);
		style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setDataFormat(df.getFormat("d-mmm"));
		styles.put("cell_bg", style);

		Font font3 = wb.createFont();
		font3.setFontHeightInPoints((short) 14);
		font3.setColor(IndexedColors.DARK_BLUE.getIndex());
		font3.setBoldweight(Font.BOLDWEIGHT_BOLD);
		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_LEFT);
		style.setFont(font3);
		style.setWrapText(true);
		styles.put("cell_h", style);

		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_LEFT);
		style.setWrapText(true);
		styles.put("cell_normal", style);

		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setWrapText(true);
		styles.put("cell_normal_centered", style);

		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_RIGHT);
		style.setWrapText(true);
		style.setDataFormat(df.getFormat("d-mmm"));
		styles.put("cell_normal_date", style);

		style = createBorderedStyle(wb);
		style.setAlignment(CellStyle.ALIGN_LEFT);
		style.setIndention((short) 1);
		style.setWrapText(true);
		styles.put("cell_indented", style);

		style = createBorderedStyle(wb);
		style.setFillForegroundColor(IndexedColors.BLUE.getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		styles.put("cell_blue", style);

		return styles;
	}

	private static CellStyle createBorderedStyle(Workbook wb) {
		CellStyle style = wb.createCellStyle();
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		style.setBorderTop(CellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.BLACK.getIndex());
		return style;
	}
}