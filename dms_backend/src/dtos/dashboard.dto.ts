export interface DashboardSummaryDto {
  pending: number;
  delivered: number;
  today: number;
  cancelled: number;
}

export interface RecentOrderDto {
  id: number;
  order_number: string;
  customer_name: string;
  delivery_address: string;
  delivery_latitude?: number;
  delivery_longitude?: number;
  status: string;
}

export interface DashboardResponseDto {
  success: boolean;
  message: string;
  summary: DashboardSummaryDto;
  recentOrders: RecentOrderDto[];
}