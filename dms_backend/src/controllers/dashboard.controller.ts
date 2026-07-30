import {
  Controller,
  Get,
  Route,
  Tags,
  Security,
  SuccessResponse,
  Response,
} from "tsoa";

import dashboardService from "../services/dashboard.service";

import {
  DashboardResponseDto,
} from "../dtos/dashboard.dto";

@Route("dashboard")
@Tags("Dashboard")
export class DashboardController extends Controller {

  /**
   * Dashboard Summary & Recent Orders
   */
  @Get()
  @Security("BearerAuth")
  @SuccessResponse("200", "Dashboard Loaded")
  @Response("401", "Unauthorized")
  public async getDashboard(): Promise<DashboardResponseDto> {

    try {

      return await dashboardService.getDashboard();

    } catch (err: any) {

      this.setStatus(500);

      return {
        success: false,
        message: err.message,
        summary: {
          pending: 0,
          delivered: 0,
          today: 0,
          cancelled: 0,
        },
        recentOrders: [],
      };
    }
  }
}